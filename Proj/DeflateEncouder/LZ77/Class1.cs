using System;

namespace LZ77
{
    [Flags]
    public enum Color
    {
        Black,
        Nigger = 101,
        Red = 201 
    }
    public class LZ77Compressor:ICompressor 
    {
    }

    public interface ICompressor
    {
        byte[] CompressData(byte [] input);
        byte[] DecompressData(byte [] input);
    }
}
