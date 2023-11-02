import 'package:flutter/material.dart';

class ShapeConstants {
  static const double shapeRadiusS = 4.0;
  static const double shapeRadiusM = 8.0;
  static const double shapeRadiusL = 16.0;
  static const double shapeRadiusXL = 24.0;
  static const double shapeRadiusXXL = 32.0;
}

class Shape {
  static final BorderRadiusGeometry roundedS =
      BorderRadius.circular(ShapeConstants.shapeRadiusS);
  static final BorderRadiusGeometry roundedM =
      BorderRadius.circular(ShapeConstants.shapeRadiusM);
  static final BorderRadiusGeometry roundedL =
      BorderRadius.circular(ShapeConstants.shapeRadiusL);
  static final BorderRadiusGeometry roundedXL =
      BorderRadius.circular(ShapeConstants.shapeRadiusXL);
  static final BorderRadiusGeometry roundedXXL =
      BorderRadius.circular(ShapeConstants.shapeRadiusXXL);
  static final RoundedRectangleBorder roundedRectangleS =
      RoundedRectangleBorder(
    borderRadius: Shape.roundedS,
  );
  static final RoundedRectangleBorder roundedRectangleM =
      RoundedRectangleBorder(
    borderRadius: Shape.roundedM,
  );
  static final RoundedRectangleBorder roundedRectangleL =
      RoundedRectangleBorder(
    borderRadius: Shape.roundedL,
  );
  static final RoundedRectangleBorder roundedRectangleXL =
      RoundedRectangleBorder(
    borderRadius: Shape.roundedXL,
  );
  static final RoundedRectangleBorder roundedRectangleXXL =
      RoundedRectangleBorder(
    borderRadius: Shape.roundedXXL,
  );
  static final RoundedRectangleBorder cardBorder = RoundedRectangleBorder(
    borderRadius: Shape.roundedM,
  );
}
