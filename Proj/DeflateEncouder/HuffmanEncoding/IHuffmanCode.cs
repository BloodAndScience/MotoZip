namespace HuffmanEncoding
{
    public interface IHuffmanCode
    {
        string Encoder(string text);
        string Decode(string text);
    }
}