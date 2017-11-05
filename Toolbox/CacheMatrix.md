# Cache Matrix
Lisa Hlmsch  



Matrix inversion is usually a costly computation and there may be some benefit to caching the inverse of a matrix rather than compute it repeatedly. The below functions are supposed to cache the inverse of a matrix

* makeCacheMatrix: This function creates a special "matrix" object that can cache its inverse.
* cacheSolve: This function computes the inverse of the special "matrix" returned by makeCacheMatrix above. 

If the inverse has already been calculated (and the matrix has not changed), then the cachesolve should retrieve the inverse from the cache.

 
### makeCacheMatrix

This function creates a list of functions to 

* set the value of the matrix
* get the value of the matrix
* set the value of the inverse matrix
* get the value of the inverse matrix


```r
makeCacheMatrix <- function(x = matrix()) {
    m <- NULL
    set <- function(y) {                
        x <<- y
        m <<- NULL
    }
    get <- function() x                 
    setsolve <- function(solve) m <<- solve 
    getsolve <- function() m             
    list(set = set, get = get,
         setsolve = setsolve,
         getsolve = getsolve)
}
```

### cacheSolve

This function computes the inverse of the special "matrix" returned by makeCacheMatrix above. 
If the inverse has already been calculated (and the matrix has not changed), then the cachesolve should retrieve the inverse from the cache.

The following function calculates the mean of the matrix created with the above function. 
However, it first checks to see if the inverse has already been calculated. 
If so, it gets the inverse from the cache and skips the computation. 
Otherwise, it calculates the inverse of the matrix and sets the value in the cache via the setsolve function.


```r
cacheSolve <- function(x, ...) {
    m <- x$getsolve()
    if(!is.null(m)) {
        message("getting cached data")
        return(m)
    }
    data <- x$get()
    m <- solve(data, ...)
    x$setsolve(m)
    m
}
```

### Testing


```r
SampleMatrix = matrix(1:4,2,2)
SampleMatrix2 = makeCacheMatrix(SampleMatrix)
cacheSolve(SampleMatrix2)
```

```
##      [,1] [,2]
## [1,]   -2  1.5
## [2,]    1 -0.5
```
