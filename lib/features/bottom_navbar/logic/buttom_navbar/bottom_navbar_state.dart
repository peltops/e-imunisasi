part of 'bottom_navbar_cubit.dart';

abstract class BottomNavbarState extends Equatable {
  final int itemIndex;
  const BottomNavbarState(this.itemIndex);

  @override
  List<Object> get props => [];
}

class BottomNavbarHome extends BottomNavbarState {
  const BottomNavbarHome(int itemIndex) : super(itemIndex);
  @override
  String toString() => 'BottomNavbarHome';
}

class BottomNavbarProfile extends BottomNavbarState {
  const BottomNavbarProfile(int itemIndex) : super(itemIndex);
  @override
  String toString() => 'BottomNavbarProfile';
}

class BottomNavbarMessage extends BottomNavbarState {
  const BottomNavbarMessage(int itemIndex) : super(itemIndex);
  @override
  String toString() => 'BottomNavbarMessage';
}

class BottomNavbarSupport extends BottomNavbarState {
  const BottomNavbarSupport(int itemIndex) : super(itemIndex);
  @override
  String toString() => 'BottomNavbarSetting';
}
