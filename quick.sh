diff -urN -X obj.txt original/linux-4.20-rc2/drivers patched/linux-4.20-rc2/drivers | sed -e 's=original/==' -e 's=patched/==' >configs/0099-lowrisc-ethernet.patch
rm -rf buildroot/output/build/linux-4.20-rc2
make -C buildroot defconfig BR2_DEFCONFIG=../configs/buildroot_defconfig
make -C buildroot
cd build && ../riscv-pk/configure --host=riscv64-unknown-elf --with-payload=../buildroot/output/images/vmlinux --enable-logo --with-logo=../configs/logo.txt --enable-print-device-tree && make
cd ..
riscv64-unknown-elf-objcopy -S -O binary --change-addresses -0x80000000 build/bbl bbl.bin
riscv64-unknown-elf-objdump -d -l -S build/bbl >bbl.dis
rm -f vmlinux.dis
#riscv64-unknown-elf-objdump -d -l -S buildroot/output/images/vmlinux >vmlinux.dis
echo Uploading to genesys2.sm
tftp genesys2.sm <<EOF
 bin
 put bbl.bin
 quit
EOF
