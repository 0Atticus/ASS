# ASS
A css precompiler inspired by sass built on ruby. <br>
WARNING! This is a work in progress, it will be updated with more features, but nothing in the current version is definitely permament.

## Installation
---
Ensure you have [ruby](https://www.ruby-lang.org/en/) installed. <br>
In a bash shell, run:
```bash
cd && git clone https://github.com/0Atticus/ASS && ass(){ bash ~/ass/ass.sh $1 $2 $3; }
```

## Documentation
---
Spacing is important, use spaces where demonstrated and do not indent in your .ass file.(WIP)
### variables
---
set variables with " = " and add them to your css file with "!name"

.ass file:
```css
string = "Hello, World!"
integer = 12
!string, !integer
```

.css file:
```css
Hello, World!, 12
```

### Looping
---

.ass file:
```css
for i in 5
!i
end
```

.css file:
```css
1
2
3
4
5
```

.ass file:
```css
index = 0
list = [2, three, 4]
for item in list
!index: !item
index += 1
end
```

.css file:
```css
0: 2
1: three
2: 4
```

## Examples
---

Using ass to style to multiple elements:

```css
colors = "background-color: #000000; color: #FFFFFF; border-color: #FFFFFF;"

p {
!colors
}

h1 {
!colors
}
```


<br>


A simple ass file for a color changing animation:

```css
@keyframes color_change {
for i in 100

!i% {
background: linear-gradient(to right, red !i%, black 0%); -webkit-background-clip: text; 
-webkit-text-fill-color: transparent;
}

end
}
```

<br>

Using ass to style many similar elements:
```css
for i in 10

p!i {
position: absolute;
left: calc(!i * 10px);
}

end
```