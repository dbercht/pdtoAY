//USE ATMEGA BUILT-INSPI////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
#define DATAOUT 11//MOSI *SPI
#define DATAIN 12//MISO - not used, but part of builtin  SPI *SPI
#define SPICLOCK  13//sck *SPI
#define SLAVESELECT 10//ss *SPI

//GLOBAL  VARIABLES
///////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
int RXpinBypass = 2; //disconnects MIDI from RX Pin During Sketch  Upload *MIDI
//MCP23S17 Port B controls BC1, BDIR and RESET
//PORT B b0 = RESET active LOW
//PORT B b1 = BDIR (Bus Direction)
//PORT B b2 = BC1 (Bus Control 1)
//PORT B b3-b7 No Connection
//Bus Control 2 (BC2) tied to +5V
//Latch Address with BC1=HIGH, BC2=HIGH, BDIR=HIGH
//Write Data to chip with BC1=LOW, BC2=HIGH, BDIR=HIGH
//Inactive State with BC1=LOW, BC2=HIGH, BDIR=LOW
//Read Data on Chip with BC1=HIGH, BC2=HIGH, BDIR=LOW
int latchAddress = 0x07; //BC1 HIGH, BDIR HIGH, RESET  HIGH*AY-3-8912
int latchData = 0x03; // BC1 LOW, BDIR HIGH, RESET  HIGH*AY-3-8912
int inactiveState = 0x01; //BC1 LOW, BDIR LOW, RESET  HIGH*AY-3-8912
int resetAY = 0x00; //BC1 LOW, BDIR LOW, RESET  LOW*AY-3-8912

int other_arduino = 3;
int this_arduino = 2;


int opcode = 0x40; //MCP2317 opcode address (Hardware Address  Disabled)*MCP23S17
int portA = 0x0A; //MCP23S17 portA outputs  address*MCP23S17
int portB = 0x1A; //MCP23S17 portB outputs  address*MCP23S17

int A = 0;  //channel A  variable\*AY-3-8912
int B = 1;  //channel B  variable*AY-3-8912
int C = 2;  //channel C  variable*AY-3-8912
int ON = 0; //enable variable, active  LOW*AY-3-8912
int OFF = 1; //disable variable, inactiveHIGH*AY-3-8912
int toneNoise = (B00111111); //mixer variable for use with enable  register7*AY-3-8912
int channelCount = 0; //variable to determine incoming MIDI  channel *MIDI
int midiByte = 0; //store serial data byte with this  variable *MIDI
int action = 0; //variable used to compile MIDI data bytes with status  byte *MIDI
int velocity = 0; //variable to store MIDI velocity data  byte *MIDI
int LEDpin = 8; //MIDI transfer status  indicator *MIDI
int note = 0; // variable to store MIDI note number (also used in non-MIDIimplemenation)

int courseValue = 0; //Course Tune Value Variable (Tone and  Envelope)*AY-3-8912
int fineValue = 0; //Fine Tune Value Variable (Tone and  Envelope)*AY-3-8912
int shapeCycle[10] = { 0,4,8,9,10,11,12,13,14,15}; //array for  possible      *AY-3-8912
//Envelope Shape and Cycle Settings.

//12BIT Tone Period Values for notes C1 through B8
//PSG Output Frequency = Clock Frequency / (16 * Tone Period Value)
//
//Clock Frequency = 2MHz
//
int NoteC1  = 3822;
int NoteCS1 = 3608;
int NoteD1  = 3405;
int NoteDS1 = 3214;
int NoteE1  = 3034;
int NoteF1  = 3214;
int NoteFS1 = 3034;
int  NoteG1  = 2863;
int NoteGS1 = 2703;
int NoteA1  = 2551;
int NoteAS1 = 2408;
int  NoteB1  = 2273;
int NoteC2  = 2145;
int NoteCS2 = 2025;
int NoteD2  = 1911;
int  NoteDS2 = 1804;
int NoteE2  = 1703;
int NoteF2  = 1607;
int NoteFS2 = 1517;
int  NoteG2  = 1432;
int NoteGS2 = 1351;
int NoteA2  = 1276;
int NoteAS2 = 1204;
int  NoteB2  = 1136;
int NoteC3  = 1073;
int NoteCS3 = 1012;
int NoteD3  = 956;
int  NoteDS3 = 902;
int NoteE3  = 851;
int NoteF3  = 804;
int NoteFS3 = 758;
int  NoteG3  = 716;
int NoteGS3 = 676;
int NoteA3  = 638;
int NoteAS3 = 602;
int  NoteB3  = 568;
int NoteC4  = 536;
int NoteCS4 = 506;
int NoteD4  = 478;
int  NoteDS4 = 451;
int NoteE4  = 426;
int NoteF4  = 402;
int NoteFS4 = 379;
int  NoteG4  = 358;
int NoteGS4 = 338;
int NoteA4  = 319;
int NoteAS4 = 301;
int  NoteB4  = 284;
int NoteC5  = 268;
int NoteCS5 = 253;
int NoteD5  = 239;
int  NoteDS5 = 225;
int NoteE5  = 213;
int NoteF5  = 201;
int NoteFS5 = 190;
int  NoteG5  = 179;
int NoteGS5 = 169;
int NoteA5  = 159;
int NoteAS5 = 150;
int  NoteB5  = 142;
int NoteC6  = 134;
int NoteCS6 = 127;
int NoteD6  = 119;
int NoteDS6 = 113;
int NoteE6  = 106;
int NoteF6  = 100;
int NoteFS6 = 95;
int NoteG6  = 89;
int NoteGS6 = 84;
int NoteA6  = 79;
int NoteAS6 = 75;
int  NoteB6  = 71;
int NoteC7  = 67;
int NoteCS7 = 63;
int NoteD7  = 60;
int  NoteDS7 = 56;
int NoteE7  = 53;
int NoteF7  = 47;
int NoteFS7 = 45;
int  NoteG7  = 42;
int NoteGS7 = 38;
int NoteA7  = 36;
int NoteAS7 = 34;
int  NoteB7  = 32;
int NoteC8  = 30;
int NoteCS8 = 28;
int NoteD8  = 27;
int  NoteDS8 = 25;
int NoteE8  = 24;
int NoteF8  = 22;
int NoteFS8 = 21;
int  NoteG8  = 20;
int NoteGS8 = 19;
int NoteA8  = 18;
int NoteAS8 = 17;
int  NoteB8  = 16;

int NoteArray[96] = {
 NoteC1, NoteCS1, NoteD1, NoteDS1,NoteE1, NoteF1,
 NoteFS1,
 NoteG1, NoteGS1, NoteA1, NoteAS1, NoteB1, NoteC2, NoteCS2, NoteD2,
 NoteDS2, NoteE2,
 NoteF2, NoteFS2, NoteG2, NoteGS2, NoteA2, NoteAS2, NoteB2, NoteC3,
 NoteCS3, NoteD3,
 NoteDS3, NoteE3, NoteF3, NoteFS3, NoteG3, NoteGS3, NoteA3, NoteAS3,
 NoteB3, NoteC4,
 NoteCS4, NoteD4, NoteDS4, NoteE4, NoteF4, NoteFS4, NoteG4, NoteGS4,
 NoteA4, NoteAS4,
 NoteB4, NoteC5, NoteCS5, NoteD5, NoteDS5, NoteE5, NoteF5, NoteFS5,
 NoteG5, NoteGS5,
 NoteA5, NoteAS5, NoteB5, NoteC6, NoteCS6, NoteD6, NoteDS6, NoteE6,
 NoteF6, NoteFS6,
 NoteG6, NoteGS6, NoteA6, NoteAS6, NoteB6, NoteC7, NoteCS7, NoteD7,
 NoteE7, NoteF7,
 NoteFS7, NoteG7, NoteGS7, NoteA7, NoteAS7, NoteB7, NoteC8, NoteCS8,
 NoteD8, NoteDS8,
 NoteE8, NoteF8, NoteFS8, NoteG8, NoteGS8, NoteA8, NoteAS8, NoteB8};



//TONE PERIODFUNCTION///////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//This function updates the 12BIT Tone Period Value for selected AY  channel
//send channel number (A,B,or C) and Tone Period Value
int Tone_Period (int channel, int value){
 courseValue = 0; //Upper Byte of Tone Period Value
 fineValue = 0; //Lower Byte of Envelope Period Value
 //The following separates Envelope Period Value into Course and  Fine TuneComponents
 for (int i=0; i<8; i++){
   bitWrite(fineValue, i, bitRead(value, i));
   bitWrite(courseValue, i, bitRead(value, i+8));
 }
 send_data ((channel * 2), fineValue); //Fine Tune Value to register  0,2 or 4
 send_data (((channel * 2)+1), courseValue); //Course Tune Value to  register1,3 or 5
}


//NOISE PERIODFUNCTION//////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//This function updates the 5 BIT Noise Period Value Noise Enabled  Channels
//Send only the 5-BIT Noise Period Control value
//Envelope Frequency = Clock/(16 * Noise Period Value)
//With Clock = 2MHz; range of Noise Frequencies is 4kHz to 125 kHz
/////////////////////////////////////////////////////////////////////////////////////
int Noise_Period (int value){
 send_data (6, value); //register 6, 5BIT value
}


//ENABLE TONEFUNCTION///////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//This function enables or disables tone on selected channel
//Does not affect other currently active or inactive tones
int Enable_Tone (int channel, int state){
 bitWrite (toneNoise,channel,state);
 send_data (7, toneNoise);
}


//ENABLE NOISEFUNCTION//////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//This function enables or disables tone on selected channel
//Does not affect other currently active or inactive tones
int Enable_Noise (int channel, int state){
 bitWrite (toneNoise, (channel+3), state);
 send_data (7, toneNoise);
}


//AMPLITUDE  FUNCTION
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//This function sets the amplitude (volume) of the selected channel
//Values between 0-15 set volume (15=max, 0=channel OFF)
//Value of 16 sets amplitude under control of Envelope Control register
//(send either a value of 16 or envelopeControl for this feature)
int Amplitude (int channel, int value){
 send_data ((channel+8), value);
}


//ENVELOPE PERIODFUNCTION///////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//This function sets the 16 BIT envelope period value
//Updates both the 8-BIT course tune and 8-BIT fine tune values
//Envelope Frequency = Clock/(256*Envelope Period Value)
//With Clock = 2MHz; range of envelope frequencies is .12Hz to 7812.5Hz
//.12Hz => 8.33 sec per cycle (Envelope Period Value = 65,536)
//7812Hz => 122 microsec per cycle (Envelope Period Value = 1)
/////////////////////////////////////////////////////////////////////////////////////
int Envelope_Period (int value){
 courseValue = 0; //Upper Byte of Envelope Period Value
 fineValue = 0; //Lower Byte of Envelope Period Value
 //The following separates Envelope Period Value into Course and  Fine TuneComponents
 for (int i=0; i<8; i++){
   bitWrite(fineValue, i, bitRead(value, i));
   bitWrite(courseValue, i, bitRead(value, i+8));
 }
 send_data (11, fineValue);
 send_data (12, courseValue);
}


//ENVELOPE SHAPE AND CYCLEFUNCTION//////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//This function controls the Envelope Shape and Cycle Control of the AY.
//Counts down the Envelope Frequency by 16, producing a 16-state per  CYCLE
//envelope pattern, defining a single or repeat cycle by setting B3-B0
//of register 13.
//B0 = HOLD: set to 1=> limits envelope to one CYCLE; 0=> repeat cycle
//B1 = ALTERNATE: set to 1=> reverse count direction after each cycle
//B2 = ATTACK: set to 1=> count up (attack); 0=> count down (decay)
//B3 = CONTINUE: set to 1=> defined by the HOLD bit; set to 0=> resets
//envelope generator to 0000 after one cycle and hold at that count
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//                                        |B3| |B2| |B1| |B0|
//
//setting=0                \______________    0    0    x    x
//
//setting=1                /|_____________           0    1    x    x
//
//setting=2                \|\|\|\|\|\|\|\           1    0    0    0
//
//setting=3                \______________           1    0    0    1
//
//setting=4                \/\/\/\/\/\/\/\           1    0    1    0
//                        _____________
//setting=5                \|                 1    0    1    1
//
//setting=6                /|/|/|/|/|/|/|/    1    1    0    0
//                         ______________
//setting=7                /                  1    1    0    1
//
//setting=8                /\/\/\/\/\/\/\/           1    1    1    0
//
//setting=9                /|_____________           1    1    1    1
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//Send a value between 0-9 to select which of the ten possible shape and
//cycle setting options.
//Channel Amplitude must be set with B5 = 1 (value 16) - use AMPLITUDE  FUNCTION
//The envelope shape and cycle setting will affect all Channels with  amplitude
//function value == 16 or == envelopeControl
int Shape_Cycle (int setting){
 send_data (13, shapeCycle[setting]);
}


//PLAY NOTE FUNCTION
/////////////////////////////////////////////////////////////////
//PART OF MIDI FUNCTIONALITY - NOT NEEDED FOR OTHERIMPLEMENTATIONS//////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
//This function takes incoming MIDI Data and translates it to Note  Data for the
//SEND DATA  function
/////////////////////////////////////////////////////////////////
int Play_Note (int noteNumber, int velocityValue, int ChannelNumber){
 noteNumber = (noteNumber - 24);  //Scale from MIDI Note Number to  NoteArrayNumber
 Enable_Tone (ChannelNumber,ON); //Enable Tone on Selected Channel  (A,B or C)
 if (velocityValue == 0){
   Amplitude (ChannelNumber,0); //Turn off sound on channel A
   noteNumber = 0; //Reset noteNumber Variable
 }
 else if (velocityValue > 0 && velocityValue <=127){ //if velocity  is valid
   velocityValue = (velocityValue/8); //Scale value to 0-15 for AY  Amplituderange
   Amplitude (ChannelNumber,velocityValue); //Set Channel Volume  (0-15)
   Tone_Period (ChannelNumber, NoteArray[noteNumber]); //Play Note  from Array
   noteNumber = 0; //Reset noteNumber Variable
 }
 else {
   //Do Nothing, Data not valid
 }
}




//SEND DATA  FUNCTION
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//This function sends register and data bytes to AY via Shift register
void send_data(byte Address, byte Data)
{
 //while(digitalRead(other_arduino))
 // {
 // }
 //digitalWrite(this_arduino, HIGH);

////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////
 //First Data Group to set Register Addess of AY Chip
 //Three Components per transfer - MCP23S17 Opcode, Port Selection,  RegisterData
 //Three transfers needed: 1 = set register address, 2 = enable AY  register
 //and 3 = return AY to inactive state
 //Send Register Address for AY to PORT A pins of MCP23S17
 digitalWrite(SLAVESELECT,LOW); //MCP23S17 slave select is active  low, begintransfer
 spi_transfer (opcode); //MCP23S17 device ID
 spi_transfer (portA); //AY Address/Data Pins connected to PORT A of  MCP23S17
 spi_transfer (Address); //AY Address BYTE (4LSBs determine 0-15)
 digitalWrite(SLAVESELECT,HIGH); //release chip, signal end of  transfer

////////////////////////////////////////////////////////////////////////////////////
 //Put AY in Latch Address Mode using PORT B of MCP23S17
 digitalWrite(SLAVESELECT,LOW); //MCP23S17 slave select is active  low, begintransfer
 spi_transfer (opcode); //MCP23S17 device ID
 spi_transfer (portB); //AY Bus Control Pins connected to PORT B of  MCP23S17
 spi_transfer (latchAddress);
 digitalWrite(SLAVESELECT,HIGH); //release chip, signal end of  transfer

////////////////////////////////////////////////////////////////////////////////////
 //Put AY in Inactive State using PORT B of MCP23S17
 digitalWrite(SLAVESELECT,LOW); //MCP23S17 slave select is active  low, begintransfer
 spi_transfer (opcode); //MCP23S17 device ID
 spi_transfer (portB); //AY Bus Control Pins connected to PORT B of  MCP23S17
 spi_transfer (inactiveState);
 digitalWrite(SLAVESELECT,HIGH); //release chip, signal end of  transfer


////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////
 //Second Data Group to send Data to AY Chip
 //Three Components per transfer - MCP23S17 Opcode, Port Selection,  Register
 //Three transfers needed: 1 = set register address, 2 = enable AY  data read,
 //and 3 = return AY to inactive state
 //Send Data to for AY to PORT A pins of MCP23S17
 digitalWrite(SLAVESELECT,LOW); //MCP23S17 slave select is active  low, begintransfer
 spi_transfer (opcode); //MCP23S17 device ID
 spi_transfer (portA); //AY Address/Data Pins connected to PORT A of  MCP23S17
 spi_transfer (Data);  //send Data associated with Register Address
 digitalWrite(SLAVESELECT,HIGH); //release chip, signal end of  transfer

////////////////////////////////////////////////////////////////////////////////////
 //Put AY in Latch Data Mode using PORT B of MCP23S17
 digitalWrite(SLAVESELECT,LOW); //MCP23S17 slave select is active  low, begintransfer
 spi_transfer (opcode); //MCP23S17 device ID
 spi_transfer (portB); //AY Bus Control Pins connected to PORT B of  MCP23S17
 spi_transfer (latchData);
 digitalWrite(SLAVESELECT,HIGH); //release chip, signal end of  transfer

////////////////////////////////////////////////////////////////////////////////////
 //Return AY to Inactive State using PORT B of MCP23S17
 digitalWrite(SLAVESELECT,LOW); //MCP23S17 slave select is active  low, begintransfer
 spi_transfer (opcode); //MCP23S17 device ID
 spi_transfer (portB); //AY Bus Control Pins connected to PORT B of  MCP23S17
 spi_transfer (inactiveState);
 digitalWrite(SLAVESELECT,HIGH); //release chip, signal end of  transfer
 //digitalWrite(this_arduino, LOW);
}


//AY CHIP RESETFUNCTION///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
int reset (){
 digitalWrite(SLAVESELECT,LOW); //MCP23S17 slave select is active  low, begintransfer
 spi_transfer (opcode); //MCP23S17 device ID
 spi_transfer (portB); //AY Reset and Bus Control Pins connected to  PORT B ofMCP23S17
 spi_transfer (resetAY); //BC1 LOW, BDIR LOW, RESET LOW (0x00)
 digitalWrite(SLAVESELECT,HIGH); //release chip, signal end of  transfer
 delay (10);

/////////////////////////////////////////////////////////////////////////////////////
 //return AY to inactive state using PORT B of MCP23S17
 digitalWrite(SLAVESELECT,LOW); //MCP23S17 slave select is active  low, begintransfer
 spi_transfer (opcode); //MCP23S17 device ID
 spi_transfer (portB); //AY Bus Control Pins connected to PORT B of  MCP23S17
 spi_transfer (inactiveState); //BC1 LOW, BDIR LOW, RESET HIGH (0x01)
 digitalWrite(SLAVESELECT,HIGH); //release chip, signal end of  transfer
}


//MCP23S17 SET UPFUNCTION/////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
int set_up (int MCPregister, int MCPdata){
 digitalWrite(SLAVESELECT,LOW); //MCP23S17 slave select is active  low, begintransfer
 spi_transfer (opcode); //MCP23S17 device ID
 LEDtest();
 spi_transfer (MCPregister); //MCP23S17 register address
 spi_transfer (MCPdata); //MCP23S17 data
 digitalWrite(SLAVESELECT,HIGH); //release chip, signal end of  transfer
}



//LED FLASH  TEST
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//Debugging purposes only - not currently used
int LEDtest (){
 for (int i=0; i<10; i++){
   digitalWrite (LEDpin, HIGH);
   delay (100);
   digitalWrite (LEDpin, LOW);
   delay (100);
 }
}



//SPI TRANSFERFUNCTION///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//spi transfer function (from ATmega168 datasheet)
char spi_transfer(volatile char data)
{
 SPDR = data;                    // Start the transmission
 while (!(SPSR & (1<<SPIF)))     // Wait for the end of the transmission
 {
 };
 return SPDR;                    // Return the received byte
}



//SKETCH  SETUP
///////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
void setup()
{
 pinMode(12, INPUT);
 pinMode (RXpinBypass, OUTPUT); //used to diconnect MIDI in from  arduinoduring sketch upload
 pinMode (LEDpin, OUTPUT); //MIDI status indicator
 digitalWrite(RXpinBypass, HIGH); //enables MIDI communication when  this pinis HIGH
 digitalWrite(LEDpin, LOW); //Turn off MIDI status indicator

 pinMode(this_arduino, OUTPUT);
 pinMode(other_arduino, INPUT);


 Serial.begin (115200); // MIDI Baud Rate = 31250 BPS
 byte i;
 byte clr;
 pinMode(DATAOUT, OUTPUT); //SPI MOSI Pin
 pinMode(DATAIN, INPUT); //SPI MISO Pin (Not Used in this implementation, butreserved)
 pinMode(SPICLOCK,OUTPUT); //SPI Clock Pin
 pinMode(SLAVESELECT,OUTPUT); //SPI SlaveSelect Pin
 delay (10);

 digitalWrite(SLAVESELECT,HIGH); //disable device

//////////////////////////////////////////////////////////////////////////////////////
 // SPCR = 01010000
 //interrupt disabled,spi enabled,msb 1st,master,clk low when idle,
 //sample on leading edge of clk,system clock/4 (fastest)
 SPCR = (1<<SPE)|(1<<MSTR);
 clr=SPSR;
 clr=SPDR;
 delay(10);

 //CONFIGURE THEMCP23S17//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////
 //b7 = 1 => registers in separate banks
 //b6 = 0 => mirror - int pins internally connected when this bit is  enabled
 //b5 = 1 => sequential operation disabled, address pointer does not  increment
 //b4 = 1 => slew rate disabled when this bit is set high
 //b3 = 0 => hardware address enable bit (disabled, sets opcode to 0x40  -enable if using
 //          multiple devices on same SPI bus - set opcode using pins  A0,A1and A2
 //b2 = 1 => open drain output set
 //b1 = 1 => sets polarity of INT pin active HIGH
 //b0 = 0 => unimplemented

//////////////////////////////////////////////////////////////////////////////////////
 set_up (0x05,B10100110); // register IOCON configuration setting

//////////////////////////////////////////////////////////////////////////////////////
 set_up (0x00,0); //set PORT A pins to OUTPUT
 set_up (0x10,0); //set PORT B pins to OUTPUT
 set_up (0x0A,0); //set PORT A pins LOW
 set_up (0x1A,0); //set PORT B pins LOW


 //set the AY-3-8912 to its inactive IDLE state; BC1=LOW, BDIR=LOW
 //Put AY in Inactive State using PORT B of MCP23S17
 digitalWrite(SLAVESELECT,LOW); //MCP23S17 slave select is active low,  begintransfer
 spi_transfer (opcode); //MCP23S17 device ID
 spi_transfer (portB); //AY Bus Control Pins connected to PORT B of  MCP23S17
 spi_transfer (inactiveState);
 digitalWrite(SLAVESELECT,HIGH); //release chip, signal end of transfer

 //reset the AY38912, turn off noise and tone
 reset();
 send_data (7, toneNoise); //turn off tone and noise on channels A,B  and C(default state)



}
int mode;
int chan;
int val;
//SKETCH  LOOP
////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
void loop(){

 //send data here - these are the functions:
 //Tone_Period (channel[A,B or C], value[1-4095])
 //Noise_Period (value[1-31])
 //Enable_Tone (channel[A,C or C], state[ON or OFF])
 //Enable_Noise (channel[A,B or C], int [ON or OFF])
 //Amplitude (channel[A,B, or C], value[0-15 or envelopeControl or 16])
 //Envelope_Period (value[1-65,536])
 //Shape_Cycle (setting[0-9])
 if(Serial.available() >2){
   mode = Serial.read();
   chan = Serial.read();
   val = Serial.read();
   switch(mode){
   case 0:
     Tone_Period(chan, NoteArray[val]);
     break;
   case 1:
     break;
   case 2:
     Enable_Tone(chan, val);
     break;
   case 3:
     Enable_Noise(chan, val);
     break;
   case 4:
     Amplitude(chan, val);
     break;
   case 5:
     send_data(12, val);
     break;
   case 7:
     send_data(11, val);
     break;
   case 6:
     Shape_Cycle(val);
     break;
   default:
   
     break;
   }
  delayMicroseconds(10);
   Serial.flush();
 }

}
