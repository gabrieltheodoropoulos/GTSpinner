**GTSpinner** is a *custom, configurable activity indicator* that can be used in iOS projects. It consists of an endless spinner which can have a bullet spinning along a circular path, as well as color trails that follow the bullet. Written in Swift 4.

![Demo](http://gtiapps.com/wp-content/uploads/2018/02/gtspinner-1.gif)

## Main Features ##

- Endless circular animation
- Optional use of animated bullet spinner
- Optional use of animated color trail
- Support of multiple colors that can rotate one after another
- Support of both clockwise and counter-clockwise direction
- Configurable through custom properties

## Configurable Properties ##

- Dimension of the spinner
- Direction of the animation (clockwise, counter-clockwise)
- Collection of rotating colors
- Thickness of the circular base
- Duration of a full round of the animation
- Color of the circular base
- Color of the bullet spinner
- Flag to control whether the trail colors should be shown
- Flag to control whether the color change should happen animated
- Flag to control whether the bullet spinner should be shown
- Flag to control whether the bullet spinner color should be updated according to the trail colors

## How To Use It ##

Clone or download the repository, get the **GTSpinner.swift** file from the **Source** folder and add it to your project. See the demo project for various examples and how the spinner can be customized by modifying its properties.

## Remarks ##

GTSpinner is a UIView subclass. Add it to your views programmatically and set its position and size by setting its frame or autolayout constraints.
