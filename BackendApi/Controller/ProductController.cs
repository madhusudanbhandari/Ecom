

using Backend.DTOS.Product;
using Backend.Interfaces;
using Microsoft.AspNetCore.Mvc;

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

    [HttpPost]
    public async Task<ActionResult> CreateAsync(CreateProductDto dto)
    {
        var product=await _productService.CreateAsync(dto);
        return Ok(product);
    }

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
}