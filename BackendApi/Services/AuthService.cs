using Backend.Data;
using Backend.DTOS.Auth;
using Backend.Interfaces;
using Backend.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

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
        throw new NotImplementedException();
    }

    public async Task<AuthResponseDto> LoginAsync(LoginDto dto)
    {
        throw new NotImplementedException();
    }
}