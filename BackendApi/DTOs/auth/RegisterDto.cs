using System.ComponentModel.DataAnnotations;

namespace Backend.DTOS.Auth;

public class RegisterDto
{
    [Required]
    public string FullName{get; set;}=string.Empty;
    [Required]
    [EmailAddress]
    public string Email{get;set;}=string.Empty;
    [Required]
    [MinLength(6)]
    public string Password{get ;set;}=string.Empty;
    [Compare("Password")]
    public string ConfirmPassword{get;set;}=string.Empty;

    [Required]
    public string Role{get;set;}="Customer";

}