#include <sys/time.h>
#include <stdio.h>
#include "my_socket.h"
#include "readn.h"
extern int enable_quickack;

ssize_t						/* Read "n" bytes from a descriptor. */
readn(int fd, void *vptr, size_t n)
{
	size_t	nleft;
	ssize_t	nread;
	char	*ptr;
    struct timeval tv;

	ptr = vptr;
	nleft = n;
	while (nleft > 0) {
        gettimeofday(&tv, NULL);
        printf("%ld.%06ld ---> read in readn start\n", tv.tv_sec, tv.tv_usec);
        if (enable_quickack > 1) {
            set_so_quickack(fd, 1);
        }
		if ( (nread = read(fd, ptr, nleft)) < 0) {
			if (errno == EINTR)
				nread = 0;		/* and call read() again */
			else
				return(-1);
		} else if (nread == 0)
			break;				/* EOF */

		nleft -= nread;
		ptr   += nread;
        gettimeofday(&tv, NULL);
        printf("%ld.%06ld ---> read in readn done (%ld bytes read)\n", tv.tv_sec, tv.tv_usec, nread);
	}
	return(n - nleft);		/* return >= 0 */
}

ssize_t                     /* Write "n" bytes to a descriptor. */
writen(int fd, const void *vptr, size_t n)
{
    size_t      nleft;
    ssize_t     nwritten;
    const char  *ptr;

    ptr = vptr;
    nleft = n;
    while (nleft > 0) {
        if ( (nwritten = write(fd, ptr, nleft)) <= 0) {
            if (nwritten < 0 && errno == EINTR)
                nwritten = 0;       /* and call write() again */
            else
                return(-1);         /* error */
        }

        nleft -= nwritten;
        ptr   += nwritten;
    }
    return(n);
}

