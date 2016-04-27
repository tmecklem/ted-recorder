#define MESSAGE_LENGTH 11
#define CHECKSUM_LENGTH 9
#define MESSAGE_START_BYTE 0xaa

byte message[MESSAGE_LENGTH];
int messagePos;

void resetMessagePtr();
bool isMessageDone();
void readMessage();
void printMessageBytes();
bool messageStarted;

void setup() {
    Serial.begin(1200);
    Serial1.begin(1200);
    resetMessagePtr();
}

void loop() {
    readMessage();
}

void readMessage() {
    messageStarted = FALSE;
    while(messageStarted == FALSE) {
        if (Serial1.available()) {
            if (Serial1.peek() == MESSAGE_START_BYTE) {
                messageStarted = TRUE;
            } else {
                Serial1.read();
            }
        }
    }
    while(!isMessageDone()) {
        if (Serial1.available()) {
            message[messagePos] = ~(Serial1.read());
            messagePos++;
        }
    }
    resetMessagePtr();
    printMessageBytes(message);
}

bool verifyMessage(byte *message) {
    byte sum = 0;
    for(int i = 0 ; i < CHECKSUM_LENGTH ; i++ ) {
        sum += message[i];
    }
    sum += message[MESSAGE_LENGTH-1];
    if(sum != 0) {
        Serial.printf(" NOT OK: %02X should have been 0x00", sum);
    }
    return sum == 0;
}

void printMessageBytes(byte *message) {
    for(int i = 0 ; i < MESSAGE_LENGTH ; i++) {
        Serial.printf("%02X", message[i]);
    }
    if(verifyMessage(message)) {
        Serial.write(" OK");
    }
    Serial.println();
}

void resetMessagePtr() {
  messagePos = 0;
}

bool isMessageDone() {
    return messagePos == 11;
}
