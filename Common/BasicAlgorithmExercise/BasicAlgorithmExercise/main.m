
#import <Foundation/Foundation.h>

// 冒泡排序 O(n^2)
void bubbleSort(int array[], int aLen) {
    for (int i = 0; i < aLen - 1; i++) {
        for (int j = aLen - 1; j > i; j--) {
            if (array[j] < array[j - 1]) {
                int temp = array[j];
                array[j] = array[j - 1];
                array[j - 1] = temp;
            }
        }
    }
}

// 选择排序 O(n^2)
void selectSort(int array[], int aLen) {
    int minIndex;
    for (int i = 0; i < aLen - 1; i++) {
        minIndex = i;
        for (int j = i + 1; j < aLen; j++) {
            if (array[j] < array[minIndex]) {
                minIndex = j;
            }
        }
        if (minIndex != i) {
            int temp = array[i];
            array[i] = array[minIndex];
            array[minIndex] = temp;
        }
    }
}

// 插入排序 O(n^2)
void insetSort(int array[], int aLen) {
    for (int i = 1; i < aLen; i++) {
        int toInsert = array[i];
        int j = i;
        while (j > 0 && toInsert < array[j - 1]) {
            array[j] = array[j - 1];
            j--;
        }
        array[j] = toInsert;
    }
}

// 快速排序 O(nlogn)
void swapAB(int array[], int i, int j) {
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
}

int quickSortPartition(int array[], int left, int right) {
    int pivotKey = left;
    int pivotValue = array[left];
    while (left < right) {
        while (left < right && array[right] >= pivotValue) {
            right--;
        }
        while (left < right && array[left] <= pivotValue) {
            left++;
        }
        swapAB(array, left, right);
    }
    swapAB(array, pivotKey, left);
    return left;
}

void quickSort(int array[], int left, int right) {
    if (left >= right) {
        return;
    }
    int pivotPosition = quickSortPartition(array, left, right);
    quickSort(array, left, pivotPosition -1);
    quickSort(array, pivotPosition + 1, right);
}

int binarySearchRecursion(int array[], int low, int high, int target) {
    if (low > high) {
        return -1;
    }
    int mid = (low + high) / 2;
    if (array[mid] > target) {
        return binarySearchRecursion(array, low, mid - 1, target);
    } else if (array[mid] < target) {
        return binarySearchRecursion(array, mid + 1, high, target);
    } else {
        return mid;
    }
}

int binarySearchNotRecursion(int array[], int low, int high, int target) {
    while (low < high) {
        int mid = (low + high) / 2;
        if (array[mid] > target) {
            high = mid - 1;
        } else if (array[mid] < target) {
            low = mid + 1;
        } else {
            return mid;
        }
    }
    return -1;
}

// 字符串反转
void reverseChars(char *chars) {
    char *begin = chars;
    char *end = chars + strlen(chars) - 1;
    while (begin < end) {
        char temp = *begin;
        *(begin++) = *end;
        *(end--) = temp;
    }
}

// 有序数组合并
void mergeArray(int a[], int aLen, int b[], int bLen, int result[]) {
    int p = 0;
    int q = 0;
    int k = 0;
    while (p < aLen && q < bLen) {
        if (a[p] < b[q]) {
            result[k] = a[p++];
        } else {
            result[k] = b[q++];
        }
        k++;
    }
    while (p < aLen) {
        result[k++] = a[p++];
    }
    while (q < bLen) {
        result[k++] = b[q++];
    }
}

// 查找第一个只出现一次的字符
char findFirstOnceChar(char *chars) {
    char result = '\0';
    int array[256];
    for (int i = 0; i < 256; i++) {
        array[i] = 0;
    }
    char *p = chars;
    while (*p != '\0') {
        array[*p]++;
        p++;
    }
    p = chars;
    while (*p != '\0') {
        if (array[*p] == 1) {
            result = *p;
            break;
        }
        p++;
    }
    return result;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        int array[] = {5, 95, 15, 85, 25, 75, 35, 65, 45, 55};
        int aLen = sizeof(array) / sizeof(int);
        bubbleSort(array, aLen);
        int target = 45;
        int index = binarySearchNotRecursion(array, 0, aLen - 1, target);
        if (index == -1) {
            NSLog(@"Not Find The Target!");
        } else {
            NSLog(@"Find The Target! The Index Is: %d", index);
        }
        
        char chars[] = "Hello World";
        reverseChars(chars);
        printf("%s", chars);
    }
    return 0;
}
