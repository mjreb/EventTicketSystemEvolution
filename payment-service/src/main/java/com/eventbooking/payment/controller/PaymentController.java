package com.eventbooking.payment.controller;

import com.eventbooking.common.dto.ApiResponse;
import com.eventbooking.payment.dto.PaymentResponse;
import com.eventbooking.payment.dto.ProcessPaymentRequest;
import com.eventbooking.payment.service.PaymentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
@Slf4j
public class PaymentController {
    
    private final PaymentService paymentService;
    
    @PostMapping("/process")
    public ResponseEntity<ApiResponse<PaymentResponse>> processPayment(
            @Valid @RequestBody ProcessPaymentRequest request) {
        log.info("Processing payment request for order: {}", request.getOrderId());
        
        PaymentResponse response = paymentService.processPayment(request);
        
        if ("succeeded".equals(response.getStatus())) {
            return ResponseEntity.ok(ApiResponse.success("Payment processed successfully", response));
        } else if (response.getRequiresAction() != null && response.getRequiresAction()) {
            return ResponseEntity.ok(ApiResponse.success("Payment requires additional authentication", response));
        } else {
            return ResponseEntity.status(HttpStatus.PAYMENT_REQUIRED)
                    .body(ApiResponse.error(response.getErrorMessage()));
        }
    }
    
    @PostMapping("/confirm/{paymentIntentId}")
    public ResponseEntity<ApiResponse<PaymentResponse>> confirmPayment(
            @PathVariable String paymentIntentId) {
        log.info("Confirming payment intent: {}", paymentIntentId);
        
        PaymentResponse response = paymentService.confirmPayment(paymentIntentId);
        return ResponseEntity.ok(ApiResponse.success("Payment confirmed successfully", response));
    }
    
    @PostMapping("/refund/{orderId}")
    public ResponseEntity<ApiResponse<PaymentResponse>> refundPayment(
            @PathVariable UUID orderId,
            @RequestParam(required = false, defaultValue = "Customer requested refund") String reason) {
        log.info("Processing refund for order: {}", orderId);
        
        PaymentResponse response = paymentService.refundPayment(orderId, reason);
        return ResponseEntity.ok(ApiResponse.success("Refund processed successfully", response));
    }
    
    @GetMapping("/status/{transactionId}")
    public ResponseEntity<ApiResponse<PaymentResponse>> getPaymentStatus(
            @PathVariable UUID transactionId) {
        log.debug("Fetching payment status for transaction: {}", transactionId);
        
        PaymentResponse response = paymentService.getPaymentStatus(transactionId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
