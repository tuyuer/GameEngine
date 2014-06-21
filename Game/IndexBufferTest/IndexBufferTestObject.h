//
//  IndexBufferTestObject.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLNode.h"
#import "HL3IndexVBO.h"

/*
 
 二，API介绍
 1，总览
 
 OpenGL ES 中通过如下函数来实现 VBO：
 
 顶点缓存对象 API
 glGenBuffers	创建顶点缓存对象
 glBindBuffer	将顶点缓存对象设置为当前数组缓存对象(array buffer object)或当前元素缓存对象(element buffer object)
 glBufferData	为顶点缓存对象申请内存空间，并进行初始化(视传入的参数而定)
 glBufferSubData	初始化或更新顶点缓存对象
 glDeleteBuffers	删除顶点缓存对象
 
 
 
 
 
 
 
 
 
 
 2，创建顶点缓存对象
 
 void glGenBuffers (GLsizei n, GLuint* buffers);
 
 参数 n ： 表示需要创建顶点缓存对象的个数；
 参数 buffers ：用于存储创建好的顶点缓存对象句柄；
 
 同第一篇文章《[OpenGL ES 01]OpenGL ES之初体验》中的讲的 render buffer 对象句柄一样，在这里，顶点缓存对象句柄始终是大于 0 的正整数，0 是 OpenGL ES 保留。该函数能够一次产生多个顶点缓存对象。
 
 3，将顶点缓存对象设置为（或曰绑定到）当前数组缓存对象或元素缓存对象
 
 void glBindBuffer (GLenum target, GLuint buffer);
 
 参数 target ：指定绑定的目标，取值为 GL_ARRAY_BUFFER（用于顶点数据） 或 GL_ELEMENT_ARRAY_BUFFER（用于索引数据）；
 参数 buffer ：顶点缓存对象句柄；
 
 4，为顶点缓存对象分配空间
 
 void glBufferData (GLenum target, GLsizeiptr size, const GLvoid* data, GLenum usage);
 
 参数 target：与 glBindBuffer 中的参数 target 相同；
 参数 size ：指定顶点缓存区的大小，以字节为单位计数；
 data ：用于初始化顶点缓存区的数据，可以为 NULL，表示只分配空间，之后再由 glBufferSubData 进行初始化；
 usage ：表示该缓存区域将会被如何使用，它的主要目的是用于提示OpenGL该对该缓存区域做何种程度的优化。其参数为以下三个之一：
 GL_STATIC_DRAW：表示该缓存区不会被修改；
 GL_DyNAMIC_DRAW：表示该缓存区会被周期性更改；
 GL_STREAM_DRAW：表示该缓存区会被频繁更改；
 
 如果顶点数据一经初始化就不会被修改，那么就应该尽量使用 GL_STATIC_DRAW，这样能获得更好的性能。
 
 5，更新顶点缓冲区数据
 
 void glBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid* data);
 
 参数 ：offset 表示需要更新的数据的起始偏移量；
 参数 ：size 表示需要更新的数据的个数，也是以字节为计数单位；
 data ：用于更新的数据；
 
 6，释放顶点缓存
 
 void glDeleteBuffers (GLsizei n, const GLuint* buffers);
 
 参数与 glGenBuffers 类似，就不再累述，该函数用于删除顶点缓存对象，释放顶点缓存。
 
 三，多面手：glVertexAttribPointer 和 glDrawElements
 在介绍如何使用 VBO 进行渲染之前，我们先来回顾一下之前使用顶点数组进行渲染用到的函数：
 
 void glVertexAttribPointer (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* ptr);
 
 参数 index ：为顶点数据（如顶点，颜色，法线，纹理或点精灵大小）在着色器程序中的槽位；
 参数 size ：指定每一种数据的组成大小，比如顶点由 x, y, z 3个组成部分，纹理由 u, v 2个组成部分；
 参数 type ：表示每一个组成部分的数据格式；
 参数 normalized ： 表示当数据为法线数据时，是否需要将法线规范化为单位长度，对于其他顶点数据设置为 GL_FALSE 即可。如果法线向量已经为单位长度设置为 GL_FALSE 即可，这样可免去不必要的计算，提升效率；
 stride ： 表示上一个数据到下一个数据之间的间隔（同样是以字节为单位），OpenGL ES根据该间隔来从由多个顶点数据混合而成的数据块中跳跃地读取相应的顶点数据；
 ptr ：值得注意，这个参数是个多面手。如果没有使用 VBO，它指向 CPU 内存中的顶点数据数组；如果使用 VBO 绑定到 GL_ARRAY_BUFFER，那么它表示该种类型顶点数据在顶点缓存中的起始偏移量。
 
 那 GL_ELEMENT_ARRAY_BUFFER 表示的索引数据呢？那是由以下函数使用的：
 
 void glDrawElements (GLenum mode, GLsizei count, GLenum type, const GLvoid* indices);
 
 参数 mode ：表示描绘的图元类型，如：GL_TRIANGLES，GL_LINES，GL_POINTS；
 参数 count ： 表示索引数据的个数；
 参数 type ： 表示索引数据的格式，必须是无符号整形值；
 indices ：这个参数也是个多面手，如果没有使用 VBO，它指向 CPU 内存中的索引数据数组；如果使用 VBO 绑定到 GL_ELEMENT_ARRAY_BUFFER，那么它表示索引数据在 VBO 中的偏移量。
 */


@interface IndexBufferTestObject : HLNode{
    HL3IndexVBO * _indexVBO;
    BOOL _dirty;
}

@end
