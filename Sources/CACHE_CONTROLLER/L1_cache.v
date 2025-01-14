module L1_CACHE_MEMORY();
parameter no_of_l1_blocks=64;        // 64 lines of cache
parameter no_of_bytes_l1_block=4;    // 4 bytes in one line
parameter l1_block_bit_size=32;      // 32 bits in one line
parameter byte_size=8;               // one byte = 8bits 
parameter no_of_address_bits=32;     // accessed using 32 bits
parameter no_of_l1_index_bits=6;     // middle part, bw offset and tag, depends on np. of lines   
parameter no_of_blkoffset_bits=2;    // 4 bytes each line, hence 2^2    
parameter no_of_l1_tag_bits=24;      // 24 tag bits 

reg [l1_block_bit_size-1:0]l1_cache_memory[0:no_of_l1_blocks-1];    //An array of blocks for L1 Cache
reg [no_of_l1_tag_bits-1:0]l1_tag_array[0:no_of_l1_blocks-1];  //Tag array for L1 
reg l1_valid[0:no_of_l1_blocks-1];      //valid array ~ 1 for valid, 0 for invalid

initial 
begin: initialization_l1           
    integer i;
    for  (i=0;i<no_of_l1_blocks;i=i+1)
    begin
        l1_valid[i]=1'b0;   // initially at t=0, cache is empty, hence all invalid
        l1_tag_array[i]=0;  //set tag to 0, can set arbitrarily
    end
end
endmodule