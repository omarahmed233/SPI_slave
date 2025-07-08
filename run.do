vlib work
vlog -f file.txt +cover
vsim -voptargs=+acc work.SPI_tb -cover

add wave *
add wave -position insertpoint  \
sim:/SPI_tb/DUT/slave/rx_valid \
sim:/SPI_tb/DUT/slave/rx_data
add wave -position insertpoint  \
sim:/SPI_tb/DUT/slave/tx_valid \
sim:/SPI_tb/DUT/slave/tx_data
add wave -position insertpoint  \
sim:/SPI_tb/DUT/memo/write_addr \
sim:/SPI_tb/DUT/memo/read_addr  \
sim:/SPI_tb/DUT/slave/nbit

coverage save SPI_wrapper.ucdb -onexit
run -all
coverage report -output report.txt -srcfile=memory_access.v -srcfile=SPI_interface.v -detail -cvg -codeAll