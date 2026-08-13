using Backend.Data;
using Backend.DTOS.Auth;
using Backend.Interfaces;
using Backend.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Backend.Services;


public class AuthService: IAuthService
{
    private readonly AppDbContext _context;
    private readonly IConfiguration _configuration;
    private readonly PasswordHasher<User> _passwordHasher;

    public AuthService(AppDbContext context, IConfiguration configuration)
    {
        _context=context;
        _configuration=configuration;
        _passwordHasher=new PasswordHasher<User>();
    }

    public async Task<AuthResponseDto> RegisterAsync(RegisterDto dto)
    {
        var existingUser=await _context.Users
        .FirstOrDefaultAsync(x=>x.Email==dto.Email);

        if (existingUser != null)
        {
            throw new Exception("Email already exists");
        }

        if (dto.Password != dto.ConfirmPassword)
        {
            throw new Exception("passwords did not match");

        }

        var user=new User
        {
            FullName=dto.FullName,
            Email=dto.Email,
            Role="Customer"
        };

        user.PasswordHash=_passwordHasher.HashPassword(user,dto.Password);
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var token=GenerateJwtToken(user);

        return new AuthResponseDto
        {
            Token=token,
            FullName=user.FullName,
            Email=user.Email,
            Role=user.Role,
        };

    }

    public async Task<AuthResponseDto> LoginAsync(LoginDto dto)
    {
        var user=await _context.Users
        .FirstOrDefaultAsync(x=>x.Email==dto.Email);

        if (user == null)
        {
            throw new Exception("Invalid Email or Password");
        }

        var result= _passwordHasher.VerifyHashedPassword(
            user,
            user.PasswordHash,
            dto.Password
        );

        if (result == PasswordVerificationResult.Failed)
        {
            throw new Exception("Invalid Email or Password");
        }

        var token=GenerateJwtToken(user);

        return new AuthResponseDto
        {
            Token=token,
            FullName=user.FullName,
            Email=user.Email,
            Role=user.Role
        };
    }

    private string GenerateJwtToken(User user)
    {
        var key=new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]!));

        var credentials=new SigningCredentials(key,
        SecurityAlgorithms.HmacSha256);

        var claims=new[]
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new Claim(ClaimTypes.Name, user.FullName),
            new Claim(ClaimTypes.Email, user.Email),
            new Claim(ClaimTypes.Role, user.Role)
        };

        var token=new JwtSecurityToken(
            issuer:_configuration["Jwt:Issuer"],
            audience:_configuration["Jwt:Audience"],
            claims:claims,
            expires:DateTime.UtcNow.AddMinutes(
                Convert.ToDouble(_configuration["jwt:ExpireMinutes"])
            ),
            signingCredentials:credentials
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
       
    }

}