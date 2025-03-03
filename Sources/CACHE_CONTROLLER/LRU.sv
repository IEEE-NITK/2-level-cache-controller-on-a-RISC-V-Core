`timescale 1ns / 1ps
// Psuedo-LRU.


module LRU #(parameter set=4 ) (//4 way set associatied
    //input [31:0] address,
    input [31:0] data,//our data to write
    input clr,// clear cache memory
    input clk
    );
     
    //setup
    reg[2:0] tree;// location address for which set to use
    reg[31:0] array[0:3];//placeholder for actual cache row
    
    always @(posedge clk or clr) begin
        if (clr) begin
            integer i;
            tree<=3'b0;//initialize tree
            for(int i=0; i<4;i++) //clearing data from cache
                array[i]<=32'b0;
            
        end else begin
                if (!tree[0]) begin //top level tree branch
                    array[{1'b0,tree[1]}]<=data;//writing data
                    tree[0]<=1;//update tree top level
                    tree[1]<=!tree[1];//update tree bottom level
                end else begin 
                    array[{1'b1,tree[2]}]<=data;//writing data 
                    tree[0]<=0;//update tree top level
                    tree[2]<=!tree[2];//update tree bottom level
                        
                end
       end         
end
endmodule
