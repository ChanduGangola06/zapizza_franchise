import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zapizza/constants/constants.dart';
import 'package:zapizza/models/api_error.dart';
import 'package:zapizza/models/foods_model.dart';
import 'package:zapizza/models/hook_models/foodlist_results.dart';

FetchFoods fetchFoodList() {
  final box = GetStorage();
  final foodlist = useState<List<FoodsModel>?>(null);
  final isLoading = useState<bool>(false);
  final isError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    String id = box.read("restaurantId");
    isLoading.value = true;

    try {
      final url = Uri.parse('$appBaseUrl/api/foods/restaurant-foods/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        foodlist.value = foodsModelFromJson(response.body);
        isLoading.value = false;
        isError.value = null;
      } else {
        isLoading.value = false;
        isError.value = apiErrorFromJson(response.body);
      }
    } catch (e) {
      isLoading.value = false;
      isError.value = apiErrorFromJson(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchFoods(
    data: foodlist.value,
    isLoading: isLoading.value,
    error: isError.value,
    refetch: refetch,
  );
}
