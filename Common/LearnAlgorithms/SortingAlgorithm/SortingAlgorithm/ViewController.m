//
//  ViewController.m
//  SortingAlgorithm
//
//  Created by 郭伟林 on 16/12/27.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - bubbleSort O(n^2)

void bubbleSort()
{
    int array[] = {5, 95, 15, 85, 25, 75, 35, 65, 45, 55};
    int arrayLength = sizeof(array) / sizeof(int);
    for (int i = 0; i < arrayLength - 1; i++) {
        for (int j = arrayLength - 1; j > i; j--) {
            if (array[j] < array[j - 1]) {
                int temp = array[j];
                array[j] = array[j - 1];
                array[j - 1] = temp;
            }
        }
    }
    
    for (int i = 0; i < arrayLength; i++) {
        printf("%d ", array[i]);
    }
}

#pragma mark - selectSort O(n^2)

void selectSort()
{
    int array[] = {5, 95, 15, 85, 25, 75, 35, 65, 45, 55};
    int arrayLength = sizeof(array) / sizeof(int);
    int minIndex;
    for (int i = 0; i < arrayLength - 1; i++) {
        minIndex = i;
        for (int j = i + 1; j < arrayLength; j++) {
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
    
    for (int i = 0; i < arrayLength; i++) {
        printf("%d ", array[i]);
    }
}

#pragma mark - insertSort O(n^2)

void insertSort()
{
    int array[] = {5, 95, 15, 85, 25, 75, 35, 65, 45, 55};
    int arrayLength = sizeof(array) / sizeof(int);
    for (int i = 1; i < arrayLength; i++) {
        int readyToInset = array[i];
        int j = i;
        while (j > 0 && readyToInset < array[j - 1]) {
            array[j] = array[j - 1];
            j--;
        }
        array[j] = readyToInset;
    }
    
    for (int i = 0; i < arrayLength; i++) {
        printf("%d ", array[i]);
    }
}

#pragma mark - quickSort O(nlogn)

void quickSort(int array[], int left, int right)
{
    if (left >= right) {
        return;
    }
    int pivotPosition = quickSortPartition(array, left, right);
    quickSort(array, left, pivotPosition - 1);
    quickSort(array, pivotPosition + 1, right);
}

int quickSortPartition(int array[], int left, int right)
{
    int pivotKey = left;
    int pivotValue = array[left];
    while (left < right) {
        while (left < right && array[right] >= pivotValue) {
            right--;
        }
        while (left < right && array[left] <= pivotValue) {
            left++;
        }
        swap(array, left, right);
    }
    swap(array, pivotKey, left);
    return left;
}

void swap(int array[], int i, int j)
{
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
}

#pragma mark -

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    bubbleSort();
    
//    selectSort();
    
//    insertSort();
    
    [self testQuickSort];
}

- (void)testQuickSort {
    
    int array[] = {5, 95, 15, 85, 25, 75, 35, 65, 45, 55};
    int arrayLength = sizeof(array) / sizeof(int);
    quickSort(array, 0, arrayLength - 1);
    for (int i = 0; i < arrayLength; i++) {
        printf("%d ", array[i]);
    }
}

@end
