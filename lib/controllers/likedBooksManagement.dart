class LikedStatusManager {
  static Map<int, bool> likedBooks = {}; // Shared liked status map

  static void updateLikedStatus(int bookId, bool isLiked) {
    likedBooks[bookId] = isLiked;
  }

  static bool isBookLiked(int bookId) {
    return likedBooks[bookId] ?? false;
  }
}