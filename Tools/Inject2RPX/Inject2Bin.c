#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include <stdio.h>
#include <limits.h>
#include <openssl/md5.h>
void freeVector(void **pVector) {
    free(*pVector);
    *pVector=NULL;
}
void *readFileData(FILE *fd,unsigned int *intDataSize) {
void *varout;
    if ((varout=malloc(*intDataSize))!=NULL) {
        if (fread(varout,*intDataSize,1,fd)!=1) {
            free(varout);
            varout=NULL;
        }
    }
    return varout;
}
void *readFileDataSegment(FILE *fd,unsigned int intOffset,unsigned int *intDataSize) {
    return (!fseek(fd,intOffset,SEEK_SET))?readFileData(fd,intDataSize):NULL;
}
int fileSize(FILE *fd) {
    return (!fseek(fd,0,SEEK_END))?ftell(fd):-1;
}
int getFileSize(const char *strFileName,FILE **fd) {
int varout=-1;
FILE *fh;
    if ((fh=fopen(strFileName,"r"))!=NULL) {
        if ((varout=fileSize(fh))==-1) {
            fclose(fh);
        }
        else {
            if (fd==NULL) {
                fclose(fh);
            }
            else {
                *fd=fh;
            }
        }
    }
    return varout;
}
int main(int intArgsCount,char *strArguments[]) {
FILE *fpRpx,*fpPatch;
char strFsObjectPath[PATH_MAX];
unsigned char btMd5Hash[MD5_DIGEST_LENGTH];
void *btFileData;
unsigned int intDataSize;
    if (intArgsCount==3) {
        if ((fpRpx=fopen(strArguments[1],"rb+"))==NULL) {
            printf("Failed to open %s file\n",strArguments[1]);
        }
        else {
            strArguments[1]=basename(strcpy(strFsObjectPath,strArguments[2]));
            if (!stricmp(&strArguments[1][41],".bin")) {
                if ((intDataSize=getFileSize(strFsObjectPath,&fpPatch))!=UINT_MAX) {
                    strArguments[1][8]=0;
                    strArguments[1][41]=0;
                    sscanf(strArguments[1],"%x",&intArgsCount);
                    if ((btFileData=readFileDataSegment(fpRpx,intArgsCount,&intDataSize))!=NULL) {
                        strArguments[1]=strArguments[1]+9;
                        printf("Injection offset: %d\nInjected data size: %d\nExpected MD5 hash: %s\nComputed MD5 hash: ",intArgsCount,intDataSize,strArguments[1]);
                        MD5(btFileData,intDataSize,btMd5Hash);
                        freeVector(&btFileData);
                        for (intArgsCount=0;intArgsCount<MD5_DIGEST_LENGTH;intArgsCount++) {
                            sprintf(strFsObjectPath,"%02x",btMd5Hash[intArgsCount]);
                            printf("%s",strFsObjectPath);
                            if (strnicmp(strFsObjectPath,&strArguments[1][intArgsCount<<1],2)) {
                                printf("\nPatch not applied\n");
                                break;
                            }
                        }
                        if (intArgsCount==MD5_DIGEST_LENGTH) {
                            if ((btFileData=readFileDataSegment(fpPatch,0,&intDataSize))!=NULL) {
                                if (fseek(fpRpx,-1*intDataSize,SEEK_CUR)) {
                                    printf("\nPatch not applied\n");
                                }
                                else {
                                    if (fwrite(btFileData,intDataSize,1,fpRpx)==1) {
                                        printf("\nPatch applied\n");
                                    }
                                    else {
                                        printf("\nPatch not applied\n");
                                    }
                                }
                                freeVector(&btFileData);
                            }
                        }
                    }
                    fclose(fpPatch);
                }
            }
            fclose(fpRpx);
        }
    }
    else {
        printf("USAGE: %s <uncompress game RPX file path> <patch file>\n",strArguments[0]);
    }
    return 0;
}
