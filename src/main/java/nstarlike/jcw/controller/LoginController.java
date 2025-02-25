package nstarlike.jcw.controller;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ResolvableType;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import nstarlike.jcw.model.User;
import nstarlike.jcw.service.LoginService;
import nstarlike.jcw.util.Validator;
import nstarlike.jcw.util.ValidatorInvalidException;

@Controller
public class LoginController {
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	private static String authorizationRequestBaseUri
    = "oauth2/authorization";
  Map<String, String> oauth2AuthenticationUrls
    = new HashMap<>();
  
	@Autowired
	private LoginService loginService;
	
	@Autowired
    private ClientRegistrationRepository clientRegistrationRepository;
	
	@GetMapping("/login")
	public String login(Model model) {
		Map<String, String> oAuth2Urls = new HashMap<>();
		Iterable<ClientRegistration> clientRegistrations = null;
		ResolvableType type = ResolvableType.forInstance(clientRegistrationRepository).as(Iterable.class);
		if(type != ResolvableType.NONE && ClientRegistration.class.isAssignableFrom(type.resolveGenerics()[0])) {
			clientRegistrations = (Iterable<ClientRegistration>)clientRegistrationRepository;
		}
		
		clientRegistrations.forEach(registration ->
			oAuth2Urls.put(registration.getClientName(), "oauth2/authorization/" + registration.getRegistrationId())
		);
		
		model.addAttribute("oAuth2Urls", oAuth2Urls);
		return "login";
	}
	
	@GetMapping("/searchId")
	public String searchId() {
		return "searchId";
	}
	
	@PostMapping("/searchIdProc")
	public String searchIdProc(@RequestParam Map<String, String> params, Model model) {
		try {
			Validator.koreanName(params.get("name"));
			Validator.email(params.get("email"));
			
			User user = new User();
			user.setName(params.get("name"));
			user.setEmail(params.get("email"));
			
			String userId = loginService.searchLoginId(user);
			
			logger.debug("userId=" + userId);
			
			model.addAttribute("alert", "Your ID is " + userId);
			model.addAttribute("replace", "/login");
		
		}catch(ValidatorInvalidException e) {
			e.printStackTrace();
			
			model.addAttribute("alert", e.getMessage());
			model.addAttribute("back", true);
			
		}catch(Exception e) {
			e.printStackTrace();
			
			model.addAttribute("alert", "Something is wrong.");
			model.addAttribute("back", true);
		}
		
		return "common/proc";
	}
	
	@GetMapping("/resetPassword")
	public String resetPassword() {
		return "resetPassword";
	}
	
	@PostMapping("/resetPasswordProc")
	public String resetPasswordProc(@RequestParam Map<String, String> params, Model model) {
		try {
			String loginId = Validator.loginId(params.get("loginId"));
			String name = Validator.koreanName(params.get("name"));
			String email = Validator.email(params.get("email"));
			
			User user = new User();
			user.setLoginId(loginId);
			user.setName(name);
			user.setEmail(email);
			
			//check if the reset password is sent.
	//		boolean isSent = userDetailsService.resetPassword(user);
			boolean isSent = true;
			if(!isSent) {
				throw new Exception ("Failed to send an email.");
			}
		
//			model.addAttribute("alert", "New password is sent to you email.");
			model.addAttribute("alert", "Your new password is password2.");
			model.addAttribute("replace", "/login");
		
		}catch(ValidatorInvalidException e) {
			e.printStackTrace();
			
			model.addAttribute("alert", e.getMessage());
			model.addAttribute("back", true);
			
		}catch(Exception e) {
			e.printStackTrace();
			
			model.addAttribute("alert", "Something is wrong.");
			model.addAttribute("back", true);
		}
		
		return "common/proc";
	}
}
