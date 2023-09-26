// haxe core
import haxe.ds.ReadOnlyArray;

// core
import zf.Assert;
import zf.Logger;
import zf.Debug;
import zf.debug.D;
// data types and data structures
import zf.Direction;
import zf.Point2i;
import zf.Point2f;
import zf.Recti;
import zf.Rectf;
import zf.Color;
import zf.Identifiable;
import zf.Pair;
import zf.ds.ArrayMap;
import zf.UpdateElements;
// update loop and animations
import zf.up.*;
import zf.up.animations.*;
// overrides
import zf.h2d.Interactive; // override the Interactive from h2d.Interactive
import zf.h2d.HtmlText; // override the HtmlText
import zf.h2d.ScaleGrid;
import zf.resources.ResourceManager;
import zf.StringTable;
import zf.h2d.ScaleGrid;
import zf.ui.ScaleGridFactory;
import zf.ui.UIElement;
import zf.ui.builder.BuilderContext;
import zf.ui.layout.*;
import zf.filters.FilterFactory;

// extensions
using zf.math.FloatExtensions;
using zf.math.IntExtensions;
using zf.math.MathExtensions;
using zf.ds.ArrayExtensions;
using zf.ds.ListExtensions;
using zf.ds.MapExtensions;
using zf.RandExtensions;
using zf.HtmlUtils;
using zf.h2d.ObjectExtensions;
using zf.h2d.col.BoundsExtensions;
using zf.up.animations.WrappedObject;
// @configure can be removed but not necessary since the 2 extensions are behind a flag
using zf.echo.BodyExtensions;
using zf.echo.ShapeExtensions;

using StringTools;
using Lambda;

import zf.SerialiseContext;
import zf.StructSerialisable;
import zf.SerialiseOption;

import world.World;
import world.WorldState;
import world.Rules;

import zf.userdata.UserData;

import userdata.Profile;

import haxe.DynamicAccess;

import zf.MessageDispatcher;

import Strings as S;
import Globals as G;
import Constants as C;
import Utils as U;
import Colors as O;

#if debug
using zf.debug.D;
#end
