// Flutter Packages
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:gold_house/data/all_static_lists.dart';
export 'package:gold_house/core/shared/custom_selectable.dart';
export 'package:shimmer/shimmer.dart';
export 'package:gold_house/presentation/home/components/description_screen.dart';
// External Packages
export 'package:carousel_slider/carousel_slider.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:intl_phone_field/intl_phone_field.dart';
export 'package:intl_phone_field/phone_number.dart';
export 'package:gold_house/data/models/order_model.dart';

// Local Constants & Services
export 'package:gold_house/core/constants/app_colors.dart';
export 'package:gold_house/data/datasources/local/hive_helper/hive_class.dart';
export 'package:gold_house/data/datasources/local/shared_preferences/shared_service.dart';

// Auth Screens
export 'package:gold_house/presentation/screens/auth/presentation/pages/sign_up.dart';
export 'package:gold_house/presentation/screens/auth/presentation/pages/otp.dart';

// Errors
export 'package:gold_house/presentation/errors/404_page.dart';
export 'package:gold_house/presentation/errors/noconnection.dart';

export 'package:gold_house/bloc/products/get_products_bloc.dart';
export 'package:gold_house/bloc/get_cities/get_cities_bloc.dart';

export 'package:gold_house/presentation/home/home_screen.dart';
export 'package:gold_house/presentation/screens/main/main_screen.dart';
export 'package:gold_house/presentation/screens/basket/presentation/pages/basket.dart';
export 'package:gold_house/presentation/screens/search/presentation/pages/search_screen.dart';
export 'package:gold_house/presentation/screens/orders/presentation/pages/orders_history.dart';
export 'package:gold_house/presentation/screens/profile/presentation/pages/profile.dart';

// Entrance Screens
export 'package:gold_house/presentation/enterance/select_business.dart';
export 'package:gold_house/presentation/enterance/select_lg.dart';
export 'package:gold_house/presentation/enterance/slelct_rg.dart';

// Widgets
export 'package:gold_house/core/shared/custom_button.dart';
export 'package:gold_house/core/shared/custom_carousel.dart';
export 'package:gold_house/core/shared/custom_searchbar.dart';
export 'package:gold_house/core/shared/custom_intel_phone.dart';
export 'package:gold_house/core/shared/selected_row.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:gold_house/bloc/login/auth_login_bloc.dart';
export 'package:gold_house/bloc/otp/otp_verification_bloc.dart';
export 'package:gold_house/bloc/register/auth_register_bloc.dart';
