using System.ComponentModel.DataAnnotations;
 public class RegisterModel{
        [Required(ErrorMessage ="Username is required")]
        [MinLength(3, ErrorMessage ="Username must be at least 3 characters.")]
        public string Username {get; set;}
        [Required(ErrorMessage ="Password is required")]
        [MinLength(8, ErrorMessage ="Password must be at least 8 characters")]
        public string Password { get; set;}
    }
