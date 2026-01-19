# Test WhatsApp Webhook Locally

Write-Host "Testing WhatsApp Webhook..." -ForegroundColor Green

# Test 1: Check API documentation
Write-Host "`n1. Opening API documentation..." -ForegroundColor Yellow
Start-Process "http://localhost:8080/docs"
Start-Sleep -Seconds 2

# Test 2: Test webhook verification (simulating Meta's verification)
Write-Host "`n2. Testing webhook verification..." -ForegroundColor Yellow
$verifyToken = "2293339004466065|Wo-2V-9DfYBtA4L1no7BvyYntlo"
$url = "http://localhost:8080/whatsapp_response?hub.mode=subscribe&hub.verify_token=$verifyToken&hub.challenge=test123"
try {
    $response = Invoke-WebRequest -Uri $url -Method GET
    Write-Host "Verification response: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "Verification failed: $_" -ForegroundColor Red
}

# Test 3: Send a test message (simulating WhatsApp sending a message)
Write-Host "`n3. Testing message processing..." -ForegroundColor Yellow
$testPayload = @{
    object = "whatsapp_business_account"
    entry = @(
        @{
            id = "WHATSAPP_BUSINESS_ACCOUNT_ID"
            changes = @(
                @{
                    value = @{
                        messaging_product = "whatsapp"
                        metadata = @{
                            display_phone_number = "15551916254"
                            phone_number_id = "984006608122464"
                        }
                        contacts = @(
                            @{
                                profile = @{
                                    name = "Test User"
                                }
                                wa_id = "94711037357"
                            }
                        )
                        messages = @(
                            @{
                                from = "94711037357"
                                id = "wamid.test123"
                                timestamp = "1234567890"
                                text = @{
                                    body = "Hi"
                                }
                                type = "text"
                            }
                        )
                    }
                    field = "messages"
                }
            )
        }
    )
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/whatsapp_response" -Method Post -Body $testPayload -ContentType "application/json"
    Write-Host "Message processing response: $response" -ForegroundColor Green
    Write-Host "`nCheck the WhatsApp webhook logs to see the processing!" -ForegroundColor Cyan
} catch {
    Write-Host "Message processing failed: $_" -ForegroundColor Red
}

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "WhatsApp Webhook Endpoints:" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Webhook URL: http://localhost:8080/whatsapp_response" -ForegroundColor White
Write-Host "API Docs:    http://localhost:8080/docs" -ForegroundColor White
Write-Host "Verify Token: 2293339004466065|Wo-2V-9DfYBtA4L1no7BvyYntlo" -ForegroundColor White

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "To connect to real WhatsApp:" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "1. Install ngrok: https://ngrok.com/" -ForegroundColor Yellow
Write-Host "2. Run: ngrok http 8080" -ForegroundColor Yellow
Write-Host "3. Copy the https URL (e.g., https://abc123.ngrok.io)" -ForegroundColor Yellow
Write-Host "4. In Meta Developer Console, set webhook to:" -ForegroundColor Yellow
Write-Host "   https://YOUR-NGROK-URL/whatsapp_response" -ForegroundColor Green
Write-Host "5. Use verify token from above" -ForegroundColor Yellow
Write-Host "6. Subscribe to 'messages' webhook events" -ForegroundColor Yellow
