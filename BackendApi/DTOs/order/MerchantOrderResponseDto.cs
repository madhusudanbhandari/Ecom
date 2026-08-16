public class MerchantOrderResponseDto
{
    public int Id { get; set; }

    public string CustomerName { get; set; } = "";

    public decimal TotalAmount { get; set; }

    public string Status { get; set; } = "";

    public DateTime CreatedAt { get; set; }

    public List<MerchantOrderItemDto> Items { get; set; } = new();
}