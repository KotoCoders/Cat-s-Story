from sys import argv
import numpy as np 
from PIL import Image
import pygame
import linear as l

class Figure:

    def __init__(self, poitns = None):
        if type(poitns) == None:
            self.poitns = []
        else:
            self.poitns = np.array(poitns, dtype='float')

    def isInternal(self, testDot) -> bool:
        inters = [0, 0]
        for dot, nextDot in self.pairs():
            for i in range(2):
                if  self.isIntersect(dot[i], nextDot[i], testDot[i]):
                    inters[i] += 1

        if sum(inters) < 4:
            return False

        for i in range(2):
            if inters[i] // 2 != 0:
                return False
        return True
    

    def add(self, other):
        if len(self.poitns) == 0:
            self.poitns = other.poitns
            print("Just rebind")
        else:
            print("Calling function")
            self.poitns = l.get_intersection(self.poitns, other.poitns)


    @staticmethod
    def checkIntersect(A, B, C, D):
        pass


    def pairs(self):
        if len(self.poitns) == 0:
            return

        i = 0 
        while i < len(self.poitns) - 1:
            yield self.poitns[i], self.poitns[i + 1]
            i += 1
        yield self.poitns[len(self.poitns) - 1], self.poitns[0]



    @staticmethod
    def isIntersect(a, b, value):
        up = max(a, b)
        down = min(a, b)
        if value <= up and value >= down:
            return True
        return False


    @staticmethod
    def getRectPoints(x, y, w, h):
        return np.array([
                (x, y),
                (x + w, y),
                (x, y + h),
                (x + w, y + h)
                ], dtype='float')

class ImageProccesor:
    
    def __init__(self, alpha = 0.3):
        self.figure = []
        self.alpha = 0.3
        self._img = None
        self.fig = Figure()

    
    @property
    def image(self):
        return self._img

    @image.setter
    def image(self, filepath):
        img = Image.open(filepath)
        img.load()
        self._img = np.asarray(img, dtype='uint8')
    
    
    def quadratVector(self, x = 0, y = 0, minSize = 10):
        W, H, C = self._img.shape
        for x in range(0, W, minSize):
            for y in range(0, H, minSize):
                slice = self._img[x:x+minSize, y:y+minSize, 3:4]
                s = np.sum(slice) / (255 * minSize**2)

                if s > self.alpha:
                    adding = Figure(Figure.getRectPoints(y, x, minSize, minSize))
                    self.fig.add(adding)
                    yield y, x, minSize, minSize 
    
    
    





def imaginarium():
    import pygame as pg
    LINE_COLOR = 0xffcbfe
    RADIUS = 10 
    
    pg.init()
    image_surface = pg.image.load(argv[1])
    image_rect = image_surface.get_rect()
    screen = pg.display.set_mode([image_rect.width + 100, image_rect.height + 100])
    screen.fill((255, 255, 255))
    screen.blit(image_surface, image_rect)
    running = True
    pg.display.update()
    rects = [] 

    c = 0
    ip = ImageProccesor()
    ip.image = argv[1]
    for newRect in ip.quadratVector():
        pg.draw.rect(screen,c,newRect, 2)
        if c == 0xffffff:
            c = 0
        else:
            c += 1
        
    fig_buff = []
    figures = []
    while running:
        for event in pg.event.get():
            if event.type == pg.QUIT:
                running = False
            if event.type == pg.MOUSEBUTTONUP:
                pos = pg.mouse.get_pos()
                print(pos)
                if len(fig_buff) != 0:
                    pg.draw.line(screen, LINE_COLOR, fig_buff[-1], pos)
                    pg.draw.circle(screen, 0xffffff, pos, RADIUS, 2)
                    if ((pos[0] - fig_buff[0][0])**2 + (pos[1] - fig_buff[0][1])**2)**0.5 < RADIUS:
                        figures.append(Figure(fig_buff))
                        print("New figure!")
                        fig_buff = []
                        LINE_COLOR += 0xaefbcd
                        break
                fig_buff.append(pos)

            if event.type == pg.KEYDOWN:
                if event.key == pg.K_RETURN:
                    #screen.fill(0xffffff)
                    #screen.blit(image_surface, image_rect)
                    n_f = Figure()
                    for f in figures:
                        n_f.add(f)
                    
                    print(n_f.poitns)

                    for dot1, dot2 in n_f.pairs():
                        dot1 = dot1.astype(int)
                        dot2 = dot2.astype(int)
                        
                        pg.draw.line(screen,0xff0000, dot1, dot2, 3)
                        pg.draw.circle(screen, 0xffffff, dot1, RADIUS, 2)
                        pg.draw.circle(screen, 0xffffff, dot2, RADIUS, 2)


        pg.display.flip()
    
    pg.quit()

print("hah")
imaginarium()
