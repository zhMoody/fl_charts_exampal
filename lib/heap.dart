abstract class Heap<E> {
  int get size;
  bool get isEmpty;
  void clear();
  void add(E element);
  E get();
  E remove();
  E? replace(E element);
}

class BinaryHeap<E> implements Heap<E> {
  static const int _defaultCapacity = 10;
  List<E?> _elements;
  int _size = 0;
  final Comparator<E>? _comparator;

  BinaryHeap(
      {List<E>? elements,
      Comparator<E>? comparator,
      int capacity = _defaultCapacity})
      : _comparator = comparator,
        _elements = List<E?>.filled(elements?.length ?? capacity, null,
            growable: false) {
    if (elements != null) {
      _size = elements.length;
      for (int i = 0; i < _size; i++) {
        _elements[i] = elements[i];
      }
      _heapify();
    }
  }

  @override
  int get size => _size;

  @override
  bool get isEmpty => _size == 0;

  @override
  void clear() {
    for (int i = 0; i < _size; i++) {
      _elements[i] = null;
    }
    _size = 0;
  }

  @override
  void add(E element) {
    _nullCheck(element);
    _ensure(_size + 1);
    _elements[_size++] = element;
    _siftUp(_size - 1);
  }

  @override
  E get() {
    _emptyCheck();
    return _elements[0]!;
  }

  @override
  E remove() {
    _emptyCheck();
    final E root = _elements[0] as E;
    _elements[0] = _elements[--_size];
    _elements[_size] = null;
    _siftDown(0);
    return root;
  }

  @override
  E? replace(E element) {
    _nullCheck(element);
    E? root;
    if (isEmpty) {
      _elements[0] = element;
      _size++;
    } else {
      root = _elements[0];
      _elements[0] = element;
      _siftDown(0);
    }
    return root;
  }

  void _siftUp(int index) {
    var i = index;
    final node = _elements[i];
    while (i > 0) {
      final parentIndex = (i - 1) >> 1;
      final parent = _elements[parentIndex];
      if (_compare(node as E, parent as E) <= 0) break;
      _elements[i] = parent;
      i = parentIndex;
    }
    _elements[i] = node;
  }

  void _heapify() {
    for (int i = (_size >> 1) - 1; i >= 0; i--) {
      _siftDown(i);
    }
  }

  void _siftDown(int index) {
    var i = index;
    final element = _elements[i];
    final half = _size >> 1;
    while (i < half) {
      int childIndex = (i << 1) + 1;
      var child = _elements[childIndex];
      final int rightIndex = childIndex + 1;
      if (rightIndex < _size &&
          _compare(_elements[rightIndex] as E, child as E) > 0) {
        child = _elements[rightIndex];
        childIndex = rightIndex;
      }

      if (_compare(element as E, child as E) >= 0) break;
      _elements[i] = child;
      i = childIndex;
    }
    _elements[i] = element;
  }

  void _nullCheck(E? element) {
    if (element == null) {
      throw ArgumentError("Element cannot be null.");
    }
  }

  void _emptyCheck() {
    if (isEmpty) {
      throw StateError("Heap is empty.");
    }
  }

  void _ensure(int capacity) {
    if (_elements.length >= capacity) return;
    final int newCapacity = _elements.length + (_elements.length >> 1);
    List<E?> newElements = List<E?>.filled(newCapacity, null, growable: false);
    for (int i = 0; i < _size; i++) {
      newElements[i] = _elements[i];
    }
    _elements = newElements;
  }

  int _compare(E a, E b) {
    return _comparator?.call(a, b) ?? (a as Comparable).compareTo(b);
  }

  static BinaryHeap<E> heapOf<E>(List<E> elements) {
    return BinaryHeap<E>(elements: elements);
  }
}
