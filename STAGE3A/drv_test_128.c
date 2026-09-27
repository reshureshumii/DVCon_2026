#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char *argv)
{

	float data[16384] = {
		0,
	};
	// float data[10]={11,12,13,14,15,16,17,18,19,20};
	float temp_array[16384] = {
		0,
	};
	int length = 16384;
	char option;
	int fd;
	unsigned int matrix_a = 0xBF000000;
	unsigned int matrix_b = 0xBF100000;
	unsigned int matrix_c = 0xBF200000;
	unsigned int temp = 0;

	printf("DVCon Accelerator App\n");
	fd = open("/dev/accelerator_test", O_RDWR);
	if (fd < 0)
	{
		printf("Cannot open device file...\n");
		return 0;
	}
	
for(int k=1;k<11;k++)
	{	

		

		for (int i = 0; i < 16384; i++)
		{
			data[i] = k; //rand() % 10;
		}
		printf("Data: %d\n",k);

		temp = 0;
		pwrite(fd, &temp, 1, 0x0); // Stop accelerator

		pread(fd, &temp, 1, 0x0); // Dummy read of accelerator base
		
		pwrite(fd, &data, 16384, matrix_a);	
		pwrite(fd, &data, 16384, matrix_b);
		
			
		// Initializing Accelerator with RAM Addresses
		pwrite(fd, &matrix_a, 1, 0x10);
		temp = 0;
		pwrite(fd, &temp, 1, 0x14);
		pwrite(fd, &matrix_b, 1, 0x1c);
		temp = 0;
		pwrite(fd, &temp, 1, 0x20);
		pwrite(fd, &matrix_c, 1, 0x28);
		temp = 0;
		pwrite(fd, &temp, 1, 0x2c);
		temp = 1;
		
		pwrite(fd, &temp, 1, 0x0); // Start accelerator

		while (1) // Waiting for acceleratot status
		{
			pread(fd, &temp, 1, 0x0); // Dummy read of accelerator base
			
			if ((temp & 0x2) == 0x2)
			{
				printf("Result Generated\n\r");
				break;
			}
		}
		//getchar();
		printf("Result Matrix \n");
		pread(fd, &temp_array, 10, (matrix_c));		
		for (int i = 0; i < 10; i++)
		{
			printf("%f\n", temp_array[i]);
		}		

		temp = 0;
		pwrite(fd, &temp, 1, 0x0); // Stop accelerator
		
		
	}
	if (close(fd) == -1) {
			perror("Error closing file");
			return 1;
	    	}
	
}
