namespace Backend.DTOS.Order;

public class CreateOrderDto
{
    public List<CreateOrderItemDto> Items{get;set;}=new();
}