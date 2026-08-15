using Backend.Data;
using Backend.DTOS.Product;
using Backend.Interfaces;
using Backend.Models;
using Microsoft.EntityFrameworkCore;


namespace Backend.Services;
public class ProductService : IProductService
{
    private readonly AppDbContext _context;

    public ProductService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<List<ProductResponseDto>> GetAllAsync()
    {
       return await _context.Products
       .Select(product=>new ProductResponseDto
       {
           Id=product.Id,
           Name=product.Name,
           Description=product.Description,
           Price=product.Price,
           Stock=product.Stock,
           ImageUrl=product.ImageUrl
       }) 
       .ToListAsync();
    }

   public async Task<ProductResponseDto?> GetByIdAsync(int id)
    {
        var product= await _context.Products.FindAsync(id);

        if(product==null)
        return null;

        return new ProductResponseDto
        {
            Id=product.Id,
            Name=product.Name,
            Description=product.Description,
            Price=product.Price,
            Stock=product.Stock,
            ImageUrl=product.ImageUrl
        };
    }

    public async Task<ProductResponseDto> CreateAsync(CreateProductDto dto,int merchantId)
    {
        var product = new Product
        {
            Name = dto.Name,
            Description = dto.Description,
            Price = dto.Price,
            Stock = dto.Stock,
            ImageUrl = dto.ImageUrl,

            MerchantId=merchantId
        };

        _context.Products.Add(product);

        await _context.SaveChangesAsync();

        return new ProductResponseDto
        {
            Id = product.Id,
            Name = product.Name,
            Description = product.Description,
            Price = product.Price,
            Stock = product.Stock,
            ImageUrl = product.ImageUrl
        };
    }

    public async Task<ProductResponseDto?> UpdateAsync(int id, UpdateproductDto dto)
    {
        var product = await _context.Products.FindAsync(id);

        if (product == null)
            return null;

        product.Name = dto.Name;
        product.Description = dto.Description;
        product.Price = dto.Price;
        product.Stock = dto.Stock;
        product.ImageUrl = dto.ImageUrl;

        await _context.SaveChangesAsync();

        return new ProductResponseDto
        {
            Id = product.Id,
            Name = product.Name,
            Description = product.Description,
            Price = product.Price,
            Stock = product.Stock,
            ImageUrl = product.ImageUrl
        };
    }
    public async Task<bool> DeleteAsync(int id)
    {
        var product=await _context.Products.FindAsync(id);

        if(product==null)
        return false;

        _context.Products.Remove(product);
        await _context.SaveChangesAsync();

        return true;
    }

    public async Task<List<ProductResponseDto>> GetByMerchantIdAsync(
        int merchantId
    )
    {
        return await _context.Products
        .Where(p=>p.MerchantId==merchantId)
        .Select(p=>new ProductResponseDto
        {
            Id=p.Id,
            Name=p.Name,
            Description=p.Description,
            Price=p.Price,
            Stock=p.Stock,
            ImageUrl=p.ImageUrl
        }).ToListAsync();
    }
}