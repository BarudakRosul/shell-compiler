#!/bin/bash
#
# Author: FajarKim (Rangga Fajar Oktariansyah)
# GitHub: https://github.com/FajarKim
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I��D����k̅�LH}v�OP.�� �p1M�,�3T�S��`>� �^����RKuy0��!?�c}�6��[�|�,%�F�m�r�[ߠ��'�VG#�ϸ��H��x������O�
�&�F(+�R�f&8� F~�<�>��q݂.�x���'���B�f-'��پ֮�f�\d'�`ނ$��ߴ�j��H!�ҽx,�/m�˱e��M��/��A���Z��`�4H�3����/6H����eo=�7Ԝ,���jm�_��XB��HT�m��a�@F�@_@	Zo� z����dm��K`�g��5�ב���Y=�!�k�7k��X�W�$����B�h�BH�98�����f�,����u(��<�f�H��`LpЦ�yl�U�Ӹ��G��ޥ%�����)�"�[����0A�W��]���$�e哊��R{ai���ŉy,���}�B��נ�q������Y��3b�'W�� ��(s���S�خ�q~�n�O:�a��it^����Jn3�����2ؘNc��^,ܲ�-�'`,��z�����Z�����t9Z[7Pt?��Gf�{�J�47��Z��ws~R��YP�Y	�O Z��>�Z�zi��&�VM��ޯ� ��\�������8��)z�e�&�4���Hx���sw��x[�Z���<
��/�k�B�J�:;�y�g���a���Q�o�{"ăg�E��h��B�^�=uu�P�:Iy����fHUq��E���Ff	�ܶ!�����7f�lY�y�J\t.;��E|pסc㝝򎋻@�c����N���9J���X����9�|W�옪���f��*\\�f�b9�P_�#^m"��:`|G}0<�B���;�ztA�Kt�g.���9K��$e���F�R�T�C�+�^V�5��>����;/<DeQ
���Z���T���� �t��o��[Ѭ�A$�^N��`H&���j�`)�U�R��jۆr+��9{�!�y.�XW'A?���>y����Z�S3��#�7^�P%q��Ʒ�z� ��s<�S�f�����v ^��?�?�����+�~�h}�l��놂�+o*�T�=�^�yڼ�7D�儬D��)���#m���)s� I��Ș�5�g��F�a�@dH�my,��g�e=(���@����N.��k�<�L��U��lX��i2����_⠽���"ʩ�ݏ�&��"i��{f��������f�CQ��`�,lJ����ɃÒ'�X.:�Ml���u%�;%�1�L�=	XRz��Zȯ��t�����ц���`�~��D �s��g�]����sb��?�S���d)����Aʅ����\��Y��?�Y�~5J�b=m}b:�A��?K�QS"��$C���? [��i�<��-��f�#���<�[�6o���S��*��L;�.��H����!m6ɇ�Ow�Θ�w�������=��'�M�G�_�q�}i>C�:���W{5�5$�@`�3;j-X�j"�P���!F�����/v�H�D�*��hA����5��.���P ���=de �T'�V����tt����aY�}�v~L�S�\] �U�J��ꝯʗ2E8?٥�p]�~-�M��S�M�gN��_�T��v.������>��T*M�݋Ǣ�CF!�.Jm��l�����J#�6�=�,��]ٓ��RN/hL��5����.����t��*8�sςfn���I/
�w �.j��^�5��v����`9��j���'�m�����C�/�wq��?24^'s>(J4�����Ԭ΍�~��M��[*k-�0;b_���k��?h���0�B8���N���2��5�@x���
�wb��z
G|��!UB��M�M��d�:��@Xn@�ٚϛ�������� ��"�.�"���T���P�8_ˊ!���f_�@h����Y���m.1�=��&�7�NM[�@y)���40:�S��S��F���s��i�D6G��$��8�~J4��N��5����#�Ue�⥤�zWX�4\��jٍI��{����pQ±��Q���՜��K�O�E��H��0�(aP鑶�#؋�M����@g��_���O����˂�f��"=�c�V�0�����w��!���`
K�Lή{�v=�I���qpw ���$_1�E���	3U-���#&T�����
�[ϣ���[�#
\�u?~�V�O��%����cֱ���$���ΚT��:Y_b8�PMgk���dK�����b��������y�؜�l�ZC�����W�A��+4���qTE�3Qg�j���B����OGؿW�s��0����,�9{���O���G��9k�o꩷���H30�cLE��'�g1�$�D��⒪�z�/=S�R�͚�VE�����l2c]���x�}��K;rhj�~pIص�/������l��M�Dt��? ���ϵ*F��b�ʁ��=�aMH�x@%��b�e�`�90s�[�f%�A�zˎ��_&��pc�%�Iy
�`i��î� �# ���Éj`���c>�%�Z����4	gU�L�߲G���(��B�k�5XH(˭��W�z԰#�L�3u���˙���4������B��Gju�gn���V�u"�X���W�!(��=��J=e:T�G��[z�t���b�F��`��mi��q�V��$($�H�C�.H"u� ��X# ��D�O�~L��)v^�R�������ǈ����y[�F3�5�G��}�Ԯ�i	��S�e&/����rq!H�ǯnQ#z�g��(վ҂��������#0�@�ƩQi?�\����	St�7pa�F���'|��9�K4ea��svd�R����q �y�D���o�W��@���Z$������>�D@��=��Y�5���
����/�r�o`)�T��n���e�`S*�Lq�Q���HU<�5Sm�@�X2����9�dɟm#{'���%��u7ۏ�ʻ� 5x�Z]�q�v� ����|��h[���;�h���	,_$��%�"������FAWV���:a� �A� 2[�%���PGS��L��+B0�ܯ t�τ���Ĝ�opl\x�~��2D�����#'�jP\�
ӕ7�Z�/���Mp�9���2?��*����s$�/}�żs��x� ޛ~Ў��.�#�� �~���q!a`�����Hܗ�����A���z�,���=$�>�S�*>ܾe�i�˒��Km�h�`��:w�����6]�AP�P�ZXt���f"��ź�6�D)Hy�4B>w�c����F�@)JT'�&��c���hA�ӵ1�V,�!1��/������r��n����ڞa�ӝ���,]9�1���9l���T��,ǇzB5o+1ek�f�,�楴dO�n없����u���E3Ad,�r��Up���P��<A��	��b��M���o_��֯0�[Փ�j��x2���x��(��V%�#��0�o�`$y������n�=��I���=]���t��2��?���b�/4��ǩ,?\��+0��E�|��춂��x��
�y�*��|�C�54ѝ�u�)Е��M��U����M����/%�aՔRV�^�%���D��㐚1e�6ޤȦ/0}�7���7� Ѐ����lA8�n���)�K()���K��!�9���8hc\�OĎ#�|nIq0�:��+3=�
��M:[Z8z��a���LU%��~9 o��e��)z]�$4s�B���1%+���ZQ[o�Q�T\S�+GU�j��{�{G�%����oޘitH9�U�b�����2����k&��<k���J,�g��l�����R�c�}�j�Z�����xF�f�m�p�HD����x,�M�wszx�T��\�Z�T��IMΎo�_�MZ@��:@�1��6)��q���c��4~VM�y�z꿱5�S������Ѝ�<�ߩ��9��sh�v���ny���'��9)`+���+Ή���H��R3�b^��7m|���j����g4)쵃F-Da��p9GCS�|�j���<ѱ������[35W�"26翓��륱u�aj�h������ʘ�|�±��Q����������(�-u�(��F׾+�qr�5=LWz�|�r�P��_]���%Y�5��<IР���v`�<^��ӀL�x��Pt5�B��W���J�����j[g,j�$ek�t�M����ý���n��Y+E���|�Ψ�tZ(�~�8#��ټ�/U��]��:��k<�Ȕ�.�ݠ�w陸�}d���g��꺒��6�nE��d�h�w�M>u K��� �����f���J|��P�� Z5��8�Q��W�@�5D�|���-j������ͱ�]�8团~�z6k�ɑ\c����e|ѿ^�Q�sb��a�G����̲��y�o�W�D���٤v��0l���S6k�O"���7�A+jU8{dI�%	��pyה�qJ�_��WN���%Cg����Z�Ks����y�Z:G�%c�A�J�J)I��J͟W�磡@c) ��=��]��ϧ�=�k�&�7��E�ƿ��3?�]�5zGKw�੘
�ļ�B���VDy=�5C��y=�qq2�\��'��A�OY̕�����%l��ʹy#`��QD�X��~�ߊ���j��Q���֫D)�ep�E��������n^�`��(���ٸO�-Jd�i��*d��ej��4�#�޾�����a>ǈ�;~����,��}��Z.٭��X���f/R:2��֯�����m�5�g�v���\����%!�;��S0��L����Ae�� :���,f�2\���F�ś��7ത����W���nQ{iYX����xm�z��{��8�&��Mޭ�@w���#�ͣ����oZ� bA��ҟ,�p��9�O�h�X�i[�A�y98�����xD�����d3����A�㲓�'oڣ�9V�����X�h,����2jHÑ�����VѾ�5%�Xzw���QhE[&	�Z���v2r$]��):�f<�*y��/��'aFI�%(ꚕ���Y��#Q��W��1�ﴐj0c;Т��b��l�8�R���'�G�N9x2�8N��������gҬ��M��oK�7���t�(d��nZ/~�F�PKC_�����n���ɮI����ڱ�ZP��=�^�4I�8Z����O<�q����ն{�K�xQ6̡�5�ь�n���a�Y�=��'�5.6�î���Bȇ��G��wd_T��`Mj��~%k�@$�Yy��[r�^3J�Gp꾒�qT������Н%��#�Z|fH�`y�%�,d,�������R���f��v���i<����3�!�;a��he9���ǋ�$ڦڠVjc��{I��Z79j��0rU�1����/�a�=��tJ|���F���