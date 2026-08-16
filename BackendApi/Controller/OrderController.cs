using System.Security.Claims;
using Backend.DTOS.Order;
using Backend.Interfaces;
using Backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers;


[ApiController]
[Route("api/[controller]")]

public class OrderController: ControllerBase{
    private readonly IOrderService _orderService;

    public OrderController(IOrderService orderService)
    {
        _orderService=orderService;
    }

    [Authorize(Roles ="Customer")]
    [HttpPost]
    public async Task<IActionResult> CreateOrder(CreateOrderDto dto)
    {
        var customerId=int.Parse(
            User.FindFirstValue(ClaimTypes.NameIdentifier)!
        );

        var order=await _orderService.CreateOrderAsync(customerId,dto);

        return Ok(order);
    }

    [Authorize(Roles ="Customer")]
    [HttpGet("my-orders")]
    public async Task<IActionResult> GetMyOrders()
    {
        var customerId=int.Parse(
            User.FindFirstValue(ClaimTypes.NameIdentifier)!
                    );

                    var orders=await _orderService.GetCustomerOrdersAsync(customerId);

                    return Ok(orders);
    }

    [Authorize(Roles ="Merchant")]
    [HttpGet("merchant-orders")]
    public async Task<IActionResult> GetMerchantOrders()
    {
        var merchantId=int.Parse(
            User.FindFirstValue(ClaimTypes.NameIdentifier)!
        );

        var orders=await _orderService.GetMerchantOrdersAsync(merchantId);
        return Ok(orders);
    }

    [Authorize(Roles ="Merchant")]
    [HttpPut("{id}/status")]
    public async Task<IActionResult> UpdateStatus(
        int id,
        UpdateOrderStatusDto dto
    )
    {
        var updated=await _orderService.UpdateStatusAsync(id,dto.Status);

        if(!updated)
        return NotFound();

        return Ok();
    }

}