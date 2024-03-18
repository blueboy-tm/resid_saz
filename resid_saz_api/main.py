from PIL import Image, ImageFont, ImageDraw
from fastapi.responses import StreamingResponse
import requests
from io import BytesIO
from fastapi import FastAPI, Body

proxies = {'http': "socks5://localhost:1080",
           "https": "socks5://localhost:1080"}

fanums = {
    '0': '۰',
    '1': '۱',
    '2': '۲',
    '3': '۳',
    '4': '۴',
    '5': '۵',
    '6': '۶',
    '7': '۷',
    '8': '۸',
    '9': '۹',
}


def eng2fa(number):
    eng = ''
    for i in number:
        eng += fanums.get(i, i)
    return eng


def secureText(number: str):
    try:
        return f'{number[0:4]} {number[4:6]}** **** {number[12:]}'
    except:
        return ''


class Receipt(object):
    def __init__(
            self, sender: str,
            senderCard: str, receiver: str,
            receiverCard: str, amount: int, date: str,
            code: str) -> None:
        self.sender = sender
        self.senderCard = senderCard
        self.receiver = receiver
        self.receiverCard = receiverCard
        self.amount = amount
        self.date = date
        self.code = code
        self.bankImage = f'https://sadad.shaparak.ir/Images/BinLogo/{self.receiverCard[0:6]}.png'
        self.base = Image.open('images/receipt.png')
        self.W, self.H = self.base.size
        self.draw = ImageDraw.Draw(self.base)

    def bold(self, font_size: int):
        return ImageFont.truetype('fonts/IranYekan-Bold.ttf', font_size)

    def extra_bold(self, font_size: int):
        return ImageFont.truetype('fonts/IranYekan-ExtraBold.ttf', font_size)

    def light(self, font_size: int):
        return ImageFont.truetype('fonts/IranYekan-Light.ttf', font_size)

    def medium(self, font_size: int):
        return ImageFont.truetype('fonts/IranYekan-Medium.ttf', font_size)

    def regular(self, font_size: int):
        return ImageFont.truetype('fonts/IranYekan-Regular.ttf', font_size)

    def centerText(self, y: int, text: str, font=None, fill=None):
        _, _, w, h = self.draw.textbbox((0, 0), text, font=font)
        self.draw.text(((self.W-w)/2, y), text, font=font,
                       fill=fill, direction="rtl")

    def text(self, x, y: int, text: str, font=None, fill=None):
        self.draw.text((x, y), text, font=font, fill=fill, direction="rtl")

    def make(self):
        self.centerText(210, self.receiver, font=self.bold(28), fill="#283130")
        self.centerText(245, eng2fa(self.receiverCard),
                        font=self.medium(26), fill='#7f9797')
        self.centerText(300, eng2fa(
            f'{self.amount:,} ریال'), font=self.bold(52), fill='#283130')
        self.text(30, 582, eng2fa(self.date),
                  font=self.regular(30), fill=(41, 42, 44))
        self.text(30, 672, eng2fa(self.sender),
                  font=self.regular(30), fill=(41, 42, 44))
        self.text(30, 762, 'کارت به کارت',
                  font=self.regular(30), fill=(41, 42, 44))
        self.text(30, 852, secureText(eng2fa(self.senderCard)),
                  font=self.regular(30), fill=(41, 42, 44))
        self.text(30, 942, eng2fa(self.code),
                  font=self.regular(30), fill=(41, 42, 44))
        responce = requests.get(self.bankImage, proxies=None)
        if responce.status_code != 200:
            return
        image_file = Image.open(BytesIO(responce.content)).convert('RGBA')
        image_file = image_file.resize((23, 23))
        self.base.paste(image_file, (305, 166), image_file)

    def show(self):
        self.base.show()


app = FastAPI()


@app.post("/make/")
async def root(data: dict = Body(...)):
    receipt = Receipt(
        data.get('sender', ''),
        data.get('sender_card', ''),
        data.get('receiver', ''),
        data.get('receiver_card', ''),
        data.get('amount', 0),
        data.get('time', '') + ' ' + data.get('date', ''),
        data.get('code', ''),
    )
    receipt.make()
    image = BytesIO()
    receipt.base.save(image, format='PNG')
    image.seek(0)
    return StreamingResponse(image, media_type="image/png")
