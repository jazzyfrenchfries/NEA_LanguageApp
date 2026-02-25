using System.ComponentModel.DataAnnotations;
 public class RegisterModel{
        [Required(ErrorMessage ="Username is required")]
        [MinLength(3, ErrorMessage ="Username must be at least 3 characters.")]
        public string Username {get; set;}
        [Required(ErrorMessage ="Password is required")]
        [MinLength(8, ErrorMessage ="Password must be at least 8 characters")]
        [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$", ErrorMessage = "Password must contain at least 1 uppercase, 1 lowercase and 1 number ")]
        public string Password { get; set;}
    }
