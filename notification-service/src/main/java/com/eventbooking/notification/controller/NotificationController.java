package com.eventbooking.notification.controller;

import com.eventbooking.common.dto.ApiResponse;
import com.eventbooking.notification.dto.NotificationDto;
import com.eventbooking.notification.dto.SendNotificationRequest;
import com.eventbooking.notification.entity.NotificationStatus;
import com.eventbooking.notification.service.NotificationService;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {
    
    private static final Logger log = LoggerFactory.getLogger(NotificationController.class);
    
    private final NotificationService notificationService;
    
    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }
    
    @PostMapping("/send")
    public ResponseEntity<ApiResponse<NotificationDto>> sendNotification(
            @Valid @RequestBody SendNotificationRequest request) {
        log.info("Received request to send notification using template: {}", request.getTemplateName());
        
        NotificationDto notification = notificationService.sendNotification(request);
        
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success(notification));
    }
    
    @GetMapping("/{notificationId}")
    public ResponseEntity<ApiResponse<NotificationDto>> getNotification(
            @PathVariable UUID notificationId) {
        log.info("Fetching notification: {}", notificationId);
        
        NotificationDto notification = notificationService.getNotification(notificationId);
        
        return ResponseEntity.ok(ApiResponse.success(notification));
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<ApiResponse<Page<NotificationDto>>> getUserNotifications(
            @PathVariable UUID userId,
            @RequestParam(required = false) NotificationStatus status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        log.info("Fetching notifications for user: {}", userId);
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<NotificationDto> notifications = notificationService.getUserNotifications(userId, status, pageable);
        
        return ResponseEntity.ok(ApiResponse.success(notifications));
    }
    
    @PostMapping("/{notificationId}/resend")
    public ResponseEntity<ApiResponse<NotificationDto>> resendNotification(
            @PathVariable UUID notificationId) {
        log.info("Resending notification: {}", notificationId);
        
        NotificationDto notification = notificationService.resendNotification(notificationId);
        
        return ResponseEntity.ok(ApiResponse.success(notification));
    }
}
