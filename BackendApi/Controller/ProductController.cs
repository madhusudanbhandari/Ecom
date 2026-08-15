using Backend.DTOS.Product;
using Backend.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductController : ControllerBase
{
    private readonly IProductService _productService;

    public ProductController(IProductService productService)
    {
        _productService=productService;
    }


    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var products=await _productService.GetAllAsync();

        return Ok(products);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var product=await _productService.GetByIdAsync(id);
        return Ok(product);
    }

    [Authorize(Roles ="Merchant")]
    [HttpPost]
    public async Task<ActionResult> CreateAsync(CreateProductDto dto)
    {
        var merchantId=int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

        var product=await _productService.CreateAsync(dto,
        merchantId);
        return Ok(product);
    }

    [Authorize(Roles ="Merchant")]
    [HttpPut("{id}")]
    public async Task<ActionResult> UpdateAsync(int id, UpdateproductDto dto)
    {
        var product=await _productService.UpdateAsync(id,dto);

        if (product == null)
        {
            return NotFound(new
            {
                message="Product not found"
            });
        }
        return Ok(product);
    }

    [Authorize(Roles ="Merchant")]
    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteAsync(int id)
    {
        var deleted=await _productService.DeleteAsync(id);

        if (!deleted)
        {
            return NotFound(new
            {
                message="Product not found"
            }
            );

        }
        return Ok(new
        {
            message="Product deleted successfully"
        });
    }

    [Authorize(Roles ="Merchant")]
    [HttpGet("my-products")]
    public async Task<IActionResult> GetMyProducts()
    {
        var merchantId=int.Parse(
            User.FindFirstValue(ClaimTypes.NameIdentifier)!
        );

        var products=await _productService.GetByMerchantIdAsync(merchantId);

        return Ok(products);
    }
}