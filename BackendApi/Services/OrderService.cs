using Backend.Data;
using Backend.DTOS.Order;
using Backend.Interfaces;
using Backend.Models;
using Microsoft.EntityFrameworkCore;

namespace Backend.Services;

public class OrderService : IOrderService
{
    private readonly AppDbContext _context;

    public OrderService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<OrderResponseDto> CreateOrderAsync(
        int customerId,
        CreateOrderDto dto)
    {
        if (dto.Items == null || !dto.Items.Any())
        {
            throw new Exception("Order must contain at least one item.");
        }

        decimal totalAmount = 0;

        var orderItems = new List<OrderItem>();

        foreach (var item in dto.Items)
        {
            var product = await _context.Products
                .FirstOrDefaultAsync(p => p.Id == item.ProductId);

            if (product == null)
            {
                throw new Exception($"Product {item.ProductId} not found.");
            }

            if (product.Stock < item.Quantity)
            {
                throw new Exception($"{product.Name} does not have enough stock.");
            }

            totalAmount += product.Price * item.Quantity;

            orderItems.Add(new OrderItem
            {
                ProductId = product.Id,
                Quantity = item.Quantity,
                Price = product.Price
            });

            // Reduce stock
            product.Stock -= item.Quantity;
        }

        var order = new Order
        {
            CustomerId = customerId,
            TotalAmount = totalAmount,
            Status = "Pending",
            CreatedAt = DateTime.UtcNow
        };

        _context.Orders.Add(order);

        await _context.SaveChangesAsync();

        foreach (var item in orderItems)
        {
            item.OrderId = order.Id;
        }

        _context.OrderItems.AddRange(orderItems);

        await _context.SaveChangesAsync();

        return new OrderResponseDto
        {
            Id = order.Id,
            TotalAmount = order.TotalAmount,
            Status = order.Status,
            CreatedAt = order.CreatedAt
        };
    }

    public async Task<List<OrderResponseDto>> GetCustomerOrdersAsync(
        int customerId)
    {
        return await _context.Orders
            .Where(o => o.CustomerId == customerId)
            .OrderByDescending(o => o.CreatedAt)
            .Select(o => new OrderResponseDto
            {
                Id = o.Id,
                TotalAmount = o.TotalAmount,
                Status = o.Status,
                CreatedAt = o.CreatedAt
            })
            .ToListAsync();
    }

    public async Task<List<OrderResponseDto>> GetMerchantOrdersAsync(
        int merchantId)
    {
        return await _context.OrderItems
            .Where(oi => oi.Product.MerchantId == merchantId)
            .Select(oi => oi.Order)
            .Distinct()
            .OrderByDescending(o => o.CreatedAt)
            .Select(o => new OrderResponseDto
            {
                Id = o.Id,
                TotalAmount = o.TotalAmount,
                Status = o.Status,
                CreatedAt = o.CreatedAt
            })
            .ToListAsync();
    }
}