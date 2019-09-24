
# Goal

The goal of ECS here is to allow us to build the game logic using ECS.
HUD and other stuffs should not be rendered using ECS (probably), and might be better off using the basic objects.

# Usage

Current goal is to use this repo as a boilerplate rather than a module.
Might consider making it a module/package in the future if I need.

# Other Considerations

## GridComponent vs SpaceComponent

In the GridComponent, we set the SpaceComponent's x & y value instead of setting the x/y value of the RenderComponent.

There is a simple way to think about this.
- GridComponent tells us the position of the entity on the grid.
- SpaceComponent tells us the position of the entity in the continous space.
- RenderComponent stores the renderable and the x/y position is tied to the space component.


## GridComponent vs GridSystem

It is also possible to provide a generic grid system that makes use of the grid component.
However, what you want to store in the grid system differ from games to games.

