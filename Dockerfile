# # Stage 1

# FROM golang:1.24 as base

# # Set Working directory in the container
# WORKDIR /app

# # Copy the dependencies to the container
# COPY go.mod ./

# # Install the dependencies
# RUN go mod download

# # Copy all the files to the container
# COPY . .

# # Build the Go Application
# RUN go build -o main

 

# # Stage 2

# FROM gcr.io/distroless/base

# # Copy the binary from the previous stage
# COPY --from=base /app/main .

# # Copy the static files from the previous stage
# COPY --from=base /app/static .

# # Expose the port for which the  application is running in the container 
# EXPOSE 8080

# # Execute the built Go binary file
# CMD ["./main"]


# Stage 1 - Build
FROM golang:1.24 as builder

# Set the working directory
WORKDIR /app

# Copy go.mod and download dependencies
COPY go.mod ./
RUN go mod download

# Copy the entire application source
COPY . .

# Ensure the binary is built with the correct settings
RUN go build -o main .

# Stage 2 - Run
FROM gcr.io/distroless/base

# Set the working directory in the container
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/main .

# Copy static files if your app requires them
COPY --from=builder /app/static ./static

# Expose the port
EXPOSE 8080

# Run the application
CMD ["./main"]
