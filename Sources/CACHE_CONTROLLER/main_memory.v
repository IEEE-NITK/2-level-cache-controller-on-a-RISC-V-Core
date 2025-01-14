module MAIN_MEMORY();

parameter mm_no_of_blocks=16384;  // 2^14 Lines in main memoru
parameter mm_blocksize=32;        // one block = 32 bits = 4bytes
parameter mm_blocksize_bytes=4;   // 32bits = 4 bytes
parameter byte_size=8;            // 1byte=8bits
parameter mm_byte_size=65536;     // total main memory size in bytes ~ 64kb

reg [mm_blocksize-1:0]main_memory[0:mm_no_of_blocks-1];
initial 
begin: initialization_mm
    integer i;
    for (i=0;i<mm_no_of_blocks;i=i+1)
    begin
        main_memory[i]=i;       //we can randomly intialize with some other value as well here
    end
end
endmodule