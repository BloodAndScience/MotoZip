namespace LZ77
{
    public interface ICompressor
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        byte[] CompressData(byte [] input);
        byte[] DecompressData(byte [] input);
    }
}