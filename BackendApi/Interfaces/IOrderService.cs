using Backend.DTOS.Order;

namespace Backend.Interfaces;

public interface IOrderService
{
    Task<OrderResponseDto> CreateOrderAsync(
        int customerId,
        CreateOrderDto dto
    );

    Task<List<OrderResponseDto>> GetCustomerOrdersAsync(
        int  customerId
    );

    Task<List<OrderResponseDto>> GetMerchantOrdersAsync(
        int merchantId
    );

    Task<bool> UpdateStatusAsync(int orderId, string status);
}