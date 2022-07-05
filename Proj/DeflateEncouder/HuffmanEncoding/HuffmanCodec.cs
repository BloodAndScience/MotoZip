using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using DotNetty.Common.Utilities;


namespace HuffmanEncoding
{
    public class HuffmanCodec: IHuffmanCode,IComparer<HuffmanCodec.Node>
    {
        public Dictionary<char,string> huffmanTable;
        private Node _root;
        public static string _prefix = "EncodedValue=";

        public class Node:IComparable<Node>
        {
            public char Key;
            public int Value { get; }
            public Node Left;
            public Node Right;

            public Node(char c, int value,Node left=null,Node right = null)
            {
                 Key= c;
                Value = value;
                this.Left = left;
                this.Right = right;
            }

            public int CompareTo(Node other)
            {
                if (ReferenceEquals(this, other)) return 0;
                if (ReferenceEquals(null, other)) return 1;
                return Value.CompareTo(other.Value);
            }
        }

        void CrateTable(Node node, string encoding)
        {
            if (node.Left == (null) && node.Right == null)
            {
                huffmanTable.Add(node.Key,encoding);
                return;
            }
            CrateTable(node.Left,encoding+"0");
            CrateTable(node.Right,encoding+"1");

        }

        public string Encoder(string text)
        {
            huffmanTable = new Dictionary<char, string>();
            var countingTable = new Dictionary<char, int>();

            for (int i = 0; i < text.Length; i++)
            {
                char c = text[i];
                if(!countingTable.ContainsKey(c))
                    countingTable.Add(c,0);
                countingTable[c]++;

            }

            var pq = new PriorityQueue<Node>(this);

            foreach (var entry in countingTable)
                pq.Enqueue(new Node(entry.Key,entry.Value));

            _root = null;
            
            while (pq.Count>1)
            {
                var a = pq.Dequeue();
                var b = pq.Dequeue();
                var node = new Node('\u0000', a.Value + b.Value, a, b);
                _root = node;
                pq.Enqueue(node);

            }
            

            CrateTable(_root,"");
            StringBuilder sb = new StringBuilder(_prefix);
            for (int i = 0; i < text.Length; i++)
            {
                char c = text[i];
                sb.Append(huffmanTable[c]);

            }

            return sb.ToString();


        }

        public string Decode(string text)
        {
            var sb = new StringBuilder();
            for (int i = _prefix.Length+1; i <text.Length;)
            {

                var node = _root;
                while (node.Left!=null&&node.Right!=null)
                {
                    if (text[i] == '0')
                        node = node.Left;
                    else
                        node = node.Right;

                    i++;

                }

                sb.Append(node.Value); 

            }

            return sb.ToString();

        }

        public int Compare(Node x, Node y)
        {
            if (ReferenceEquals(x, y)) return 0;
            if (ReferenceEquals(null, y)) return 1;
            if (ReferenceEquals(null, x)) return -1;
            return x.Value.CompareTo(y.Value);
        }
    }
}
