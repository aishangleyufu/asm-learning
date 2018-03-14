#include <reg51.h>
#include <intrins.h>
#define unit unsigned int
#define uchar unsigned char
void delay_ms(int x);
void Init_Timer0(void);
void servo_interrupt(uchar act,int speed);
void Timer0_isr(void);
uchar code FFW[4]={0xf3,0xf9,0xfc,0xf6};        //四相双四拍正
uchar code REV[4]={0xf3,0xf6,0xfc,0xf9};        //四相双四拍反
uchar code FFW_1[8]={0xf1,0xf3,0xf2,0xf6,0xf4,0xfc,0xf8,0xf9};   //四相单双八拍正
uchar code REV_1[8]={0xf9,0xf8,0xfc,0xf4,0xf6,0xf2,0xf3,0xf1};   //四相单双八拍反
int i=0;
int speed=10;   //一定要用int，不能用uchar，因为2^8=256太小
uchar act_rot=0;

/*--------------主程序-----------------------*/
main(){
 Init_Timer0();
 act_rot=1;
  delay_ms(2000);             //act_rot和speed需要定义成全局变量
 act_rot=2;
 delay_ms(2000);
 act_rot=1;
 speed=20;
 delay_ms(2000);
 act_rot=2;
 delay_ms(2000);
  act_rot=0;
}
/*---------------------------------------*/

/*----------------延时1ms-----------------------*/
void delay_ms(int x)          //delay 1ms
{char i;
while(x--){for(i=114;i>0;i--){};
}
}
/*------------------------------------------------ */



/*------------------------------------------------
                    定时器初始化子程序
------------------------------------------------*/
void Init_Timer0(void)
{
 TMOD |= 0x01;	  //使用模式1，16位定时器，使用"|"符号可以在使用多个定时器时不受影响
 //TH0=0x00;	      //给定初值
 //TL0=0x00;
 EA=1;            //总中断打开
 ET0=1;           //定时器中断打开
 TR0=1;           //定时器开关打开
 PT0=1;           //优先级打开
}
/*----------------------------------------*/



/*--------舵机中断程序---必须在中断服务程序里面调用---------*/
/*------act:0 停下 1 正转 2 反转------speed 10是快 20是慢 对应中断时间（ms)--------*/
void servo_interrupt(uchar act,int speed){
 int m;                           
 m=speed*1000;
 TH0=(65536-m)/256;		  //P1的低4位控制电机
 TL0=(65536-m)%256;
 if(act==0){
 P1&=0XF0;}
 if(act==1){
 P1=FFW[i];}
 if(act==2){
 P1=REV[i];}
 i++;
 if(i==4) i=0;
}
/*-----------------------------------------------------*/


/*------------------中断服务程序------------------*/
void Timer0_isr(void) interrupt 1
{
 servo_interrupt(act_rot,speed);
}
/*------------------------------------------------*/
