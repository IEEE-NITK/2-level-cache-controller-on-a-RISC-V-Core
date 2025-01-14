module L2_CACHE_MEMORY();
parameter no_of_l2_ways=4;         //4 ways 
parameter no_of_l2_ways_bits=2;     //bits to represent 4 ways
parameter no_of_l2_blocks=128;      //no of lines in L2, note that size of L2 is greater than L1
parameter no_of_bytes_l2_block=16;  // 4 lines contain 32*4/8 = 16 bytes
parameter l2_block_bit_size=128;    // 4 lines contain 32*4 = 128 bits
parameter byte_size=8;              // 1 byte = 8 bits
parameter no_of_address_bits=32;       //bits to represent a mem location
parameter no_of_l2_index_bits=7;        // number of bits to represent 128 lines = 7
parameter no_of_blkoffset_bits=2;          //The number of bits to describe the byte in a block...2^2=4
parameter no_of_l2_tag_bits=23;            // 32-7-2 = 23 bits
reg [l2_block_bit_size-1:0]l2_cache_memory[0:no_of_l2_blocks-1];        
reg [(no_of_l2_tag_bits*no_of_l2_ways)-1:0]l2_tag_array[0:no_of_l2_blocks-1];  
reg [no_of_l2_ways-1:0]l2_valid[0:no_of_l2_blocks-1];    //valid bits firtst whole column is 0 or 1
reg [no_of_l2_ways*no_of_l2_ways_bits-1:0]lru[0:no_of_l2_blocks-1];     //

initial 
begin: initialization
    integer i;
    for  (i=0;i<no_of_l2_blocks;i=i+1)
    begin
        l2_valid[i]=0;          //initially the cache is empty
        l2_tag_array[i]=0;         //set tag to some random
        lru[i]=8'b11100100;         //set the lru values to some random permutation of 0, 1, 2, 3 initially
    end
end
endmodule