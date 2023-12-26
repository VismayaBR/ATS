import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getCarDetails(String carId) {
    return _firestore.collection('rent').doc(carId).get();
  }

  Future<void> bookCar(Map<String, dynamic> data) {
    return _firestore.collection('car_booking').add(data);
  }
}
