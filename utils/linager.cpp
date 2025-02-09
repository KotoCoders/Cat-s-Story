#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>
#include<stdio.h>
#include<stdlib.h>
// Yes, i'm a messy bastard
#include<iostream>
#include<math.h>
#include<list>

#define HALF_FLAT_CHECK(point, y_calc, use_up_flat) (point.y >= y_calc && use_up_flat || point.y <= y_calc && !use_up_flat)

namespace py = pybind11;

typedef struct{
  float x;
  float y;
} point;

typedef struct {
  point intersect_point;
  int next_dot_index;
} intersect_info;

 struct part {
  point* figure;
  int start;
  int stop;
  point intersect_dot;
};

int index(int i, int fig_size){
  if(i < 0){
    return fig_size + i;
  }

  if(i > fig_size){
    throw std::runtime_error("Index bigger then figure\n");
    return 0;
  }

  if(i == fig_size){
    return 0;
  }
  return i;
}

bool is_into(float a, float b, float c){
  float max, min;
  if(a > b){
    max = a; min = b;
  }else{
    max = b; min = a;
  }

  if (c <= max && c >= min){
    return true;
  }
  return false;
}

// Hard task
intersect_info* lines_intersection(point line[2], point figure[], int fig_size){
  //printf("Search for instersection\n");
  float k_perp, b_perp, k, b;
  bool use_up_flat;
  intersect_info* ret = (intersect_info*)malloc(sizeof(intersect_info));
  k_perp = (line[1].x - line[0].x) / (line[1].y - line[1].y);
  b_perp = line[0].y - line[0].x * k_perp;

  k = (line[0].y - line[1].y) / (line[0].x - line[1].x);
  b = line[0].y - line[0].x * k;
  
  if(line[1].y >= line[1].x * k_perp + b_perp){
    use_up_flat = true;
  } else {
    use_up_flat = false;
  }
  
  point first, second, intersect;
  float line_k, line_b;
  for(int i = 0; i < fig_size; i++){
    first = figure[i];
    second = figure[index(i + 1, fig_size)];
    //if(!HALF_FLAT_CHECK(first, (first.x * k_perp + b_perp), use_up_flat) && !HALF_FLAT_CHECK(second, (second.x * k_perp + b_perp), use_up_flat)){
    //  continue; 
    //}

    // One of the point is lying on the right surface
    line_k = (first.y - second.y)/(first.x - second.x);
    line_b = first.y - first.x * line_k;
  
    printf("(%f,%f),(%f, %f) => k, b %f, %f\n", 
        line[0].x,
        line[0].y,
        line[1].x,
        line[1].y,
    k, b); 
    //printf("k, b %f, %f\n", line_k, line_b); 
    // Lines perpendicular
    if(line_k == k){
      continue;
    }

    intersect.x = (b - line_b)/(line_k - k); 
    intersect.y = k * intersect.x + b;
    printf("Intsersect dot is (%f, %f)\n", intersect.x, intersect.y);
    printf("Find intersecting lines, testing\n"); 
    printf("Dots is (%f, %f), (%f, %f)\n",line[0].x, line[0].y, line[1].x, line[1].y);
    if(!is_into(line[0].x, line[1].x, intersect.x)){
      printf("Nan1\n");
      continue;
    }

    if(!is_into(line[0].y, line[1].y, intersect.y)){
      printf("Nan2\n");
      continue;
    }

    //printf("Dots is (%f, %f), (%f, %f)\n",first.x, first.y, second.x, second.y);
    if(!is_into(first.x, second.x, intersect.x)){
      printf("Nan3\n");
      continue;
    }

    if(!is_into(first.y, second.y, intersect.y)){
      printf("Nan4\n");
      continue;
    }
    ret->next_dot_index = index(i + 1, fig_size); 
    ret->intersect_point  = intersect;
    printf("Find intersection\n");
    return ret;
  } 
  return NULL;
}





bool is_internal(point test, point figure[], int figure_size){
  printf("testing dot (%f, %f)\n", test.x, test.y);
  point first, next;
  int x_inersections = 0, y_intersections = 0;

  for(int i = 0; i < figure_size; i++){
    first = figure[index(i, figure_size)];
    next = figure[index(i + 1, figure_size)];

    if(is_into(first.x, next.x, test.x)){
      x_inersections += 1;
    }

    if(is_into(first.y, next.y, test.y)){
      y_intersections += 1;
    }
  }
  printf("x_i, y_i (%d, %d)\n", x_inersections, y_intersections);
  if((x_inersections + y_intersections) % 2 == 0 && (x_inersections + y_intersections) >= 4){
    printf("Dot (%f, %f) is internal to A\n", test.x, test.y);
    return true;
  }
  
  return false;
}
py::array_t<float> get_intersection(py::array_t<float> figureA, py::array_t<float> figureB){
  py::buffer_info bufA = figureA.request();
  py::buffer_info bufB = figureB.request();

  if (bufA.ndim != 2 || bufB.ndim != 2){
    throw std::runtime_error("It's a 2-dimensional function\n");
  }

  if(bufA.shape[1] != 2 || bufB.shape[1] != 2){
    throw std::runtime_error("It's a 2-dimensional function\n");
  }

  point *figA =static_cast<point *>(bufA.ptr);
  point *figB =static_cast<point *>(bufB.ptr);
  
  int sizeA =  (bufA.size / 2);
  int sizeB =  (bufB.size / 2);

  std::list<point> new_figure;

  bool previos_internal = false; 
  intersect_info *info = NULL;
  int i = 0;
  int direction = 1;
  int store_counter = 0;

  point test_line[2];
  int counter = 0;
  for(counter; counter <= sizeA + 1; counter++){
    if(info != NULL){
      printf("Find intersectionnnnn!!! \n");
      // Add a intesect point 
      printf("Adding a inttersect point\n");
      new_figure.push_back(info->intersect_point);
      
      // Select new direction
      if(is_internal(figB[info->next_dot_index], figA, sizeA)){
        // So, the previos dot is not internal, selecting it
        direction = -1;
        i = index(info->next_dot_index - 1, sizeB);
      } else {
        direction = 1;
        i = index(info->next_dot_index, sizeB);
      }
      printf("Select direction %d, %d\n", direction, i);

      // Switch figure 
      point* temp_p = figA;
      figA = figB;
      figB = temp_p;

      int temp = counter;
      counter = store_counter;
      store_counter = temp;

      temp = sizeA;
      sizeA = sizeB;
      sizeB = temp;

      free(info);
      previos_internal = false;
      info = NULL;
      continue;
    }

    printf("Dot (%f, %f) with index %d\n", figA[i].x, figA[i].y, i);
    if(is_internal(figA[i], figB, sizeB)) {
      printf("  INTERNAL\n");
      if(!previos_internal && counter > 0){
        printf("Step In\n");
        test_line[0] = figA[index(i - direction, sizeA)];
        test_line[1] = figA[index(i, sizeA)];
        info = lines_intersection(test_line, figB, sizeB);
        printf("%x\n", info);
      }
      printf("Just internal\n");
      previos_internal = true;
    } else {
      // if p_i 
      printf("hah?\n");
      if(previos_internal){
        printf("Step out\n");
        // Step out
        test_line[0] = figA[index(i - direction,sizeA)];
        test_line[1] = figA[index(i, sizeA)];
        printf("Test line is index %d\n", index(i - direction, sizeA));
        printf("Test line is (%f, %f), (%f, %f)\n", 
            test_line[0].x,
            test_line[0].y,
            test_line[1].x,
            test_line[1].y);
        info = lines_intersection(test_line, figB, sizeB);
        printf("Info is %x\n", info);
        i = index(i + direction, sizeA);
        continue;
      }
      printf("Pushing dot (%f, %f)\n", figA[i].x, figA[i].y);
      new_figure.push_back(figA[i]);
      previos_internal = false;
    }
    i = index(i + direction, sizeA);
  }

  float* ret_ptr = (float*)malloc(sizeof(point)*new_figure.size());

  
  int j = 0;
  for(point arr_point : new_figure){
    ret_ptr[j] = arr_point.x;
    ret_ptr[j + 1] = arr_point.y;
    j += 2;
  }

  return py::array_t<float>(std::vector<ptrdiff_t>{new_figure.size(), 2}, &ret_ptr[0]); 
}





PYBIND11_MODULE(linear, m) {
    m.def("get_intersection", &get_intersection, "Get intersection of figures");
}
