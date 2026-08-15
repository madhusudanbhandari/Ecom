using Backend.DTOS.Product;

namespace Backend.Interfaces;

public interface IProductService
{
    Task<List<ProductResponseDto>> GetAllAsync();
    Task<ProductResponseDto?>GetByIdAsync(int id);
    Task<ProductResponseDto> CreateAsync(CreateProductDto dto,int merchantId);
    Task<ProductResponseDto> UpdateAsync(int id, UpdateproductDto dto);
    Task<bool> DeleteAsync(int id);

    Task<List<ProductResponseDto>> GetByMerchantIdAsync(int merchantId);
}